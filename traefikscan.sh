#!/bin/bash

# Global variables
BASE_PATH=""
DIALOG_CMD=$(which dialog)
BACKUP_DIR="./docker_compose_backups"
TEMP_DIR="/tmp/traefik_manager"

# Error handling function
handle_error() {
    local message="$1"
    $DIALOG_CMD --title "Error" --msgbox "$message" 10 50
    exit 1
}

# Dependency check function
check_dependencies() {
    local missing_deps=()
    
    if [ -z "$DIALOG_CMD" ]; then
        missing_deps+=("dialog")
    fi
    
    if ! command -v yq &>/dev/null; then
        missing_deps+=("yq")
    fi
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "Missing required dependencies: ${missing_deps[*]}"
        echo "Please install them using your package manager."
        echo "For example: sudo apt-get install ${missing_deps[*]}"
        exit 1
    fi
}

# Setup function
setup() {
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$TEMP_DIR"
    trap 'rm -rf "$TEMP_DIR"' EXIT
}

# Function to select base directory
select_base_directory() {
    local default_path="/root/Containers"
    
    BASE_PATH=$($DIALOG_CMD --stdout --title "Select Base Directory" \
        --dselect "$default_path" 15 60)
    
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        handle_error "Directory selection cancelled"
    fi
    
    if [ ! -d "$BASE_PATH" ]; then
        handle_error "Invalid directory: $BASE_PATH"
    fi
    
    BASE_PATH=$(realpath "$BASE_PATH")
}

# Function to detect service port
detect_service_port() {
    local file="$1"
    local service="$2"
    
    # Try to get the first exposed port from the ports section
    local exposed_port=$(yq eval ".services.$service.ports[0]" "$file" | cut -d':' -f2)
    
    # If no port is found, try to get container port from the image
    if [ "$exposed_port" = "null" ] || [ -z "$exposed_port" ]; then
        # Default to 80 if no port is found
        echo "80"
    else
        echo "$exposed_port"
    fi
}

# Function to create checklist menu
create_checklist_menu() {
    local services_file="$1"
    local temp_menu="$TEMP_DIR/menu_options"
    > "$temp_menu"
    
    local count=1
    while IFS=: read -r file service; do
        local display_name="${file##*/}:$service"
        echo "$count \"$display_name\" off" >> "$temp_menu"
        ((count++))
    done < "$services_file"
    
    echo "$temp_menu"
}

# Function to scan for docker-compose.yml files
scan_docker_compose_files() {
    local services_file="$TEMP_DIR/services.txt"
    > "$services_file"
    
    while IFS= read -r file; do
        if [ -f "$file" ]; then
            yq eval '.services | keys | .[]' "$file" 2>/dev/null | while read -r service; do
                echo "$file:$service" >> "$services_file"
            done
        fi
    done < <(find "$BASE_PATH" -type f \( -name "docker-compose.yml" -o -name "docker-compose.yaml" \))
    
    if [ ! -s "$services_file" ]; then
        handle_error "No docker-compose services found in $BASE_PATH"
    fi
    
    echo "$services_file"
}

# Function to select services
select_services() {
    local services_file="$1"
    local menu_file=$(create_checklist_menu "$services_file")
    
    local cmd=($DIALOG_CMD --stdout --title "Select Services" \
        --checklist "Choose services to add Traefik labels:" 20 70 10)
    
    while read -r line; do
        cmd+=($line)
    done < "$menu_file"
    
    "${cmd[@]}" 2>/dev/null
}

# Function to generate Traefik labels for path-based routing
generate_traefik_labels() {
    local container_name="$1"
    local port="$2"
    local folder_name="$3"
    
    # Use container name as the path
    local path_rule="/${container_name}"
    
    cat <<EOF
      - "traefik.enable=true"
      - "traefik.http.routers.${container_name}.rule=PathPrefix(\`${path_rule}\`)"
      - "traefik.http.routers.${container_name}.entrypoints=web,websecure"
      - "traefik.http.services.${container_name}.loadbalancer.server.port=${port}"
      - "traefik.http.middlewares.${container_name}-strip.stripprefix.prefixes=${path_rule}"
      - "traefik.http.routers.${container_name}.middlewares=${container_name}-strip"
EOF
}

# Function to backup file
backup_file() {
    local file="$1"
    local backup_path="$BACKUP_DIR/$(basename "$file")_$(date +%Y%m%d%H%M%S).bak"
    cp "$file" "$backup_path" || handle_error "Failed to create backup of $file"
    echo "$backup_path"
}

# Function to apply labels
apply_labels() {
    local file="$1"
    local service="$2"
    local labels="$3"
    local temp_file="$TEMP_DIR/temp.yml"
    
    # Create new YAML with labels
    yq eval ".services.$service.labels = load(\"$TEMP_DIR/labels.yml\")" "$file" > "$temp_file"
    
    # Show diff and confirm
    if diff -u "$file" "$temp_file" | $DIALOG_CMD --title "Review Changes" --programbox 20 70; then
        $DIALOG_CMD --yesno "Apply these changes?" 10 40
        if [ $? -eq 0 ]; then
            mv "$temp_file" "$file"
            return 0
        fi
    fi
    return 1
}

# Main function
main() {
    check_dependencies
    setup
    
    select_base_directory
    local services_file=$(scan_docker_compose_files)
    local selected_services=$(select_services "$services_file")
    [ -n "$selected_services" ] || exit 0
    
    # Process selected services
    for tag in $selected_services; do
        local service_info=$(sed -n "${tag}p" "$services_file")
        local file=${service_info%%:*}
        local service=${service_info#*:}
        
        # Detect the service port
        local port=$(detect_service_port "$file" "$service")
        
        # Generate and save labels
        generate_traefik_labels "$service" "$port" "$(dirname "$file")" > "$TEMP_DIR/labels.yml"
        
        # Backup and apply
        backup_file "$file"
        if apply_labels "$file" "$service" "$TEMP_DIR/labels.yml"; then
            $DIALOG_CMD --msgbox "Successfully updated $service in $file" 10 50
        else
            $DIALOG_CMD --msgbox "Skipped updating $service in $file" 10 50
        fi
    done
}

main "$@"
