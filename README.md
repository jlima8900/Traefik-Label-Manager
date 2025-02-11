# Docker Container Labels Verification Script

This script scans all running Docker containers and checks for the presence of Docker labels, specifically verifying **Traefik-related labels** for correct configuration.

## Features

- Categorizes containers based on the presence and correctness of their labels.
- Checks for containers with:
  - No labels
  - Missing or incorrect Traefik-related labels
  - Correctly configured Traefik labels
- Displays the results in both detailed sections and a summary table.

## Requirements

- Docker installed and running.
- The `jq` utility for parsing JSON.

## Installation

Clone the repository or download the script:

```bash
git clone https://github.com/yourusername/docker-label-verifier.git
cd docker-label-verifier
```

Make the script executable:

```bash
chmod +x verify_labels.sh
```

## Usage

Run the script:

```bash
./verify_labels.sh
```

The script will display the results in different sections and provide a summary table at the end.

## Output Example

```
Container Labels Verification Summary:
======================================

Containers Without Any Labels:
-------------------------------
 - mycontainer1: No Labels

Containers Without Traefik Labels:
-----------------------------------
 - mycontainer2: No Traefik Labels

Containers with Correct Traefik Labels:
---------------------------------------
 - grafana: Traefik Managed

Containers with Incorrect or Missing Traefik Labels:
-----------------------------------------------------
 - mycontainer3: Incorrect or Missing Traefik Labels

Summary Table:
==============
Container Name                          | Status                        
----------------------------------------|-------------------------------
mycontainer1                            | No Labels                     
mycontainer2                            | No Traefik Labels             
grafana                                 | Traefik Managed               
mycontainer3                            | Incorrect or Missing Traefik Labels
```

## Customization

To adjust the validation criteria for Traefik labels (e.g., host rules), modify this section of the script:

```bash
host_rule=$(echo $labels | jq -r '."traefik.http.routers.grafana.rule" // empty')
```

You can replace `"traefik.http.routers.grafana.rule"` with other Traefik rule checks as needed.

## Troubleshooting

- If `jq` is not installed, install it using:
  - **Ubuntu/Debian**: `sudo apt-get install jq`
  - **CentOS/RHEL**: `sudo yum install jq`
  - **macOS**: `brew install jq`
- Ensure Docker is running: `systemctl status docker`
