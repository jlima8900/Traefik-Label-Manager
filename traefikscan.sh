#!/bin/bash

# Get list of running containers
containers=$(docker ps -q)

echo "Container Labels Verification Summary:"
echo "======================================"

if [ -z "$containers" ]; then
  echo "No running containers found."
  exit 0
fi

declare -A no_label_containers
declare -A no_traefik_label_containers
declare -A correct_traefik_containers
declare -A incorrect_traefik_labels

# Scan each container and check for labels
for container in $containers; do
  container_name=$(docker inspect --format='{{.Name}}' $container | sed 's/^\/\(.*\)/\1/')
  labels=$(docker inspect --format='{{json .Config.Labels}}' $container | jq '.')

  if [ "$labels" == "null" ]; then
    no_label_containers["$container_name"]="No Labels"
  else
    # Check if Traefik labels exist
    if echo $labels | jq -e 'has("traefik.enable")' > /dev/null; then
      traefik_enabled=$(echo $labels | jq -r '."traefik.enable"')
      host_rule=$(echo $labels | jq -r '."traefik.http.routers.grafana.rule" // empty')

      # Verify correct Traefik configuration
      if [[ "$traefik_enabled" == "true" && -n "$host_rule" && "$host_rule" == Host* ]]; then
        correct_traefik_containers["$container_name"]="Traefik Managed"
      else
        incorrect_traefik_labels["$container_name"]="Incorrect or Missing Traefik Labels"
      fi
    else
      no_traefik_label_containers["$container_name"]="No Traefik Labels"
    fi
  fi
done

# Display results
echo -e "\nContainers Without Any Labels:"
echo "-------------------------------"
if [ ${#no_label_containers[@]} -eq 0 ]; then
  echo "All containers have labels."
else
  for container in "${!no_label_containers[@]}"; do
    echo " - $container: ${no_label_containers[$container]}"
  done
fi

echo -e "\nContainers Without Traefik Labels:"
echo "-----------------------------------"
if [ ${#no_traefik_label_containers[@]} -eq 0 ]; then
  echo "All containers have Traefik-related labels."
else
  for container in "${!no_traefik_label_containers[@]}"; do
    echo " - $container: ${no_traefik_label_containers[$container]}"
  done
fi

echo -e "\nContainers with Correct Traefik Labels:"
echo "---------------------------------------"
if [ ${#correct_traefik_containers[@]} -eq 0 ]; then
  echo "No containers have correctly configured Traefik labels."
else
  for container in "${!correct_traefik_containers[@]}"; do
    echo " - $container: ${correct_traefik_containers[$container]}"
  done
fi

echo -e "\nContainers with Incorrect or Missing Traefik Labels:"
echo "-----------------------------------------------------"
if [ ${#incorrect_traefik_labels[@]} -eq 0 ]; then
  echo "All containers with Traefik labels are correctly configured."
else
  for container in "${!incorrect_traefik_labels[@]}"; do
    echo " - $container: ${incorrect_traefik_labels[$container]}"
  done
fi

echo -e "\nSummary Table:"
echo "=============="
printf "%-40s | %-30s\n" "Container Name" "Status"
printf "%-40s | %-30s\n" "--------------------------------------" "------------------------------"

# Display No Label Containers in the Summary Table
if [ ${#no_label_containers[@]} -ne 0 ]; then
  for container in "${!no_label_containers[@]}"; do
    printf "%-40s | %-30s\n" "$container" "${no_label_containers[$container]}"
  done
fi

# Display No Traefik Label Containers in the Summary Table
if [ ${#no_traefik_label_containers[@]} -ne 0 ]; then
  for container in "${!no_traefik_label_containers[@]}"; do
    printf "%-40s | %-30s\n" "$container" "${no_traefik_label_containers[$container]}"
  done
fi

# Display Correct Traefik Containers in the Summary Table
if [ ${#correct_traefik_containers[@]} -ne 0 ]; then
  for container in "${!correct_traefik_containers[@]}"; do
    printf "%-40s | %-30s\n" "$container" "${correct_traefik_containers[$container]}"
  done
fi

# Display Incorrect Traefik Containers in the Summary Table
if [ ${#incorrect_traefik_labels[@]} -ne 0 ]; then
  for container in "${!incorrect_traefik_labels[@]}"; do
    printf "%-40s | %-30s\n" "$container" "${incorrect_traefik_labels[$container]}"
  done
fi
