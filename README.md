# TraefikScan - Automated Traefik Label Manager for Docker Compose

`traefikscan.sh` is an interactive shell script that scans for `docker-compose.yml` files, allows users to select services, and dynamically applies Traefik labels for path-based routing. It ensures proper backups before making modifications, providing a safe and efficient way to manage Traefik configurations.

## Features

- **Interactive UI**: Uses `dialog` for user-friendly navigation and selection.
- **Automated Scan**: Finds all `docker-compose.yml` files within the specified directory.
- **Selective Service Update**: Allows users to choose which services to modify.
- **Path-Based Routing**: Automatically generates and applies Traefik labels for selected services.
- **Backup Mechanism**: Creates backups of `docker-compose.yml` before applying changes.
- **Dependency Check**: Ensures `dialog` and `yq` are installed before execution.
- **Confirmation and Review**: Displays changes for review before applying modifications.

## Installation

Ensure you have the required dependencies installed:

```sh
sudo apt-get install dialog
sudo apt-get install yq
```

Clone or download this repository:

```sh
git clone https://github.com/your-repo/traefikscan.git
cd traefikscan
chmod +x traefikscan.sh
```

## Usage

Run the script:

```sh
./traefikscan.sh
```

### Steps:

1. **Select Base Directory**  
   Choose the root folder where your Docker Compose files are stored (default: `/root/Containers`).

2. **Scan for Services**  
   The script identifies all `docker-compose.yml` files and lists available services.

3. **Select Services to Update**  
   A checklist appears, allowing you to choose which services should have Traefik labels added.

4. **Review Changes**  
   Before applying changes, a `diff` comparison is shown, and you must confirm modifications.

5. **Apply Labels**  
   If confirmed, Traefik labels are added to the `docker-compose.yml` file.

6. **Completion**  
   A message box confirms which services have been successfully updated.

## Generated Traefik Labels

For each selected service, the following labels are applied:

```yaml
labels:
  - "traefik.enable=true"
  - "traefik.http.routers.<service-name>.rule=PathPrefix(`/service-name`)"
  - "traefik.http.routers.<service-name>.entrypoints=web,websecure"
  - "traefik.http.services.<service-name>.loadbalancer.server.port=80"
  - "traefik.http.middlewares.<service-name>-strip.stripprefix.prefixes=/service-name"
  - "traefik.http.routers.<service-name>.middlewares=<service-name>-strip"
```

## Backup and Safety

Before making changes, `traefikscan.sh` automatically backs up the original `docker-compose.yml` file in:

```sh
./docker_compose_backups/
```

Each backup is timestamped to ensure rollback if needed.

📌 **Created with automation for efficient Traefik management.** 🚀
