# Traefik Label Manager

**`traefik-label-manager.sh`** is an interactive Bash script for **managing Traefik labels** in `docker-compose.yml` files. It allows users to **dynamically scan, select, and apply labels** for path-based routing in Traefik with **YAML validation** and **backup handling**.

## 🔹 Features
- **Interactive Selection**: Choose which Docker Compose services to modify using a menu.
- **Automated Label Generation**: Generates **Traefik path-based routing labels** dynamically.
- **Service Port Detection**: Identifies the exposed service ports from `docker-compose.yml`.
- **YAML & Docker Compose Validation**: Ensures valid YAML before applying changes.
- **Backup Handling**: Automatically creates backups before modifying files.
- **User Confirmation**: Shows `diff` preview before applying changes.

## 📌 Requirements
- **Linux/macOS with Bash**
- **`dialog`** (for the interactive menu)
- **`yq`** (for YAML parsing)
- **`docker-compose`** (for validation)

To install dependencies, run:
```bash
sudo apt install dialog docker-compose
sudo snap install yq
```

## 🚀 Installation
1. Clone the repository (if hosted on GitHub):
   ```bash
   git clone https://github.com/YOUR_GITHUB_USERNAME/traefik-label-manager.git
   cd traefik-label-manager
   ```
2. Make the script executable:
   ```bash
   chmod +x traefik-label-manager.sh
   ```

## 🔹 Usage
1. **Run the script**:
   ```bash
   ./traefik-label-manager.sh
   ```
2. **Select the base directory** where your Docker Compose files are stored.
3. **Choose services** from the interactive checklist.
4. **Review and confirm** changes before applying labels.
5. **View results** – successfully modified files will be displayed.

## 📜 License
This project is licensed under the **Apache License 2.0**. See the full license in the [`LICENSE`](LICENSE) file.

## 🤝 Contributions
Contributions are welcome! To contribute:
1. Fork the repository.
2. Create a new branch (`git checkout -b feature-branch`).
3. Commit your changes (`git commit -m "Add new feature"`).
4. Push to your branch (`git push origin feature-branch`).
5. Create a pull request.

## 🛠 Support
If you encounter issues, feel free to open a GitHub issue or reach out. Enjoy managing your Traefik labels! 🚀
