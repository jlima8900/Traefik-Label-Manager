# 🚀 Traefik Label Manager – Your YAML Wizard! 🧙‍♂️

So, you’ve got **a bunch of Docker Compose files** running different services, and you want to expose them through **Traefik** with the right labels? Instead of wasting time **manually editing YAML files** (and probably breaking something 😅), this script **does it all for you—automatically, safely, and interactively!**  

---

## 🛠️ What This Script Actually Does:
1. **Scans your folders** looking for Docker Compose files (`docker-compose.yml` or `docker-compose.yaml`).  
2. **Lists all services** inside those files and lets you pick which ones to configure.  
3. **Detects exposed ports** (so you don’t have to dig through YAML manually).  
4. **Generates Traefik labels** dynamically for path-based routing (no more guessing).  
5. **Creates a backup** of your `docker-compose.yml` before touching anything (safety first!).  
6. **Shows a `diff` preview** so you can **see exactly what’s changing before applying it.**  
7. **Validates everything** using YAML and Docker Compose checks (so you don’t break your setup).  
8. **Asks for final confirmation** before saving the new labels into your files.  

💡 **In short**: It **analyzes your folders**, **detects services**, **maps ports**, **applies Traefik labels**, and **keeps things safe** with previews & backups. 🚀  

---

## 🎯 Why Use This? (Instead of Doing It Manually Like a Caveman 🦴)
✅ **Saves Time** – No more copy-pasting Traefik labels into YAML files.  
✅ **Prevents Errors** – Catches mistakes before they ruin your setup.  
✅ **Interactive & Easy** – Pick services via a simple menu, no CLI gymnastics required.  
✅ **Fully Automated** – Detects services, ports, and structure—so you don’t have to.  
✅ **Works With Any Docker Setup** – No special config needed.  

---

## 👨‍💻 How to Use It
1. **Run the script** (inside the folder where your `docker-compose.yml` files live):  
   ```bash
   ./traefik-label-manager.sh
   ```
2. **Select the base folder** where your Docker Compose files are stored.  
3. **Pick the services** you want to apply Traefik labels to.  
4. **Review the changes** (you’ll see exactly what’s being modified).  
5. **Confirm & Apply** – Your services now have Traefik labels and are ready to go! 🎉  

---

## 🤔 Who Should Use This?
- If you're tired of **manually adding Traefik labels** to every service.  
- If you run **multiple services** and want a **quick, error-proof way** to configure them.  
- If you like **having control** over your changes **before applying them**.  

---

## 🚀 TL;DR:
This script is like a **smart assistant** for setting up **Traefik labels in Docker Compose files**—it finds your services, lets you pick which ones to configure, detects ports, applies the correct labels, and validates everything **so you don’t break your setup**. All while keeping it **safe, interactive, and easy**.  

No more **YAML headaches**, no more **guesswork**—just **click, review, apply, and go!** 🚀😎  

