# 🐧 Make Ubuntu Look Like macOS

This script configures a macOS-like look on Ubuntu using Cupertino icons, WhiteSur GTK theme, and GNOME shell extensions.

---

## 📦 Requirements

- Ubuntu 22.04 or later
- Default GNOME desktop

---

## 🚀 How to Use

```bash
# 1. Clone or download this repository
git clone https://github.com/CristianFortunaR/MacOS-Linux-Theme.git
cd MacOS-Linux-Theme
# 2. Make the script executable
chmod +x macOs_Ubuntu.sh

# 3. Run the script with admin privileges
./macOs_Ubuntu.sh
```

⚠️ **Note:** After execution, to apply all changes:

- Log out and log in again **or**
- Press `Alt + F2`, type `r`, and press `Enter` to reload GNOME Shell

---

## 🎨 What It Does

- System update and installation of:
  - `gnome-tweaks`, `flatpak`, `gnome-shell-extension-manager`
  - Cupertino Sonoma icon theme
  - WhiteSur GTK theme (Dark variant)
- Applies:
  - GTK and icon themes
  - GNOME shell extensions:
    - Blur My Shell
    - User Themes
    - Search Light
    - GNOME 4x UI Improvements
    - Media Control
- Configures:
  - Dock (bottom, autohide, macOS look)
  - Hot corners and multitasking behavior

---

## 🛠 Customization

- To use the light theme instead, replace `WhiteSur-Dark` with `WhiteSur-Light` in the gsettings command.
- Add/remove extensions by editing the `install_and_enable_gnome_extension` function.

## ⚠️ Common Issues

### ^M at the beginning of the script (`#!/bin/bash^M`)

If you cloned or created this script on a Windows machine, it might have carriage return characters (CRLF line endings), which are incompatible with Linux shells.

### 🔍 How to check

```bash
head -n 1 macOs_Ubuntu.sh | cat -v
```

If it shows something like `#!/bin/bash^M`, the file has Windows line endings.

### 🛠 How to fix with `dos2unix`

```bash
sudo apt install dos2unix  # if not already installed
dos2unix macOs_Ubuntu.sh
```

### 💡 Alternative using `sed` (no installation required)

```bash
sed -i 's/
$//' macOs_Ubuntu.sh
```

After that, the script should run correctly in a Linux terminal.

## 🧑‍💻 Author:

**Cristian Fortuna**  
[GitHub Profile](https://github.com/cristianfortuna)  
[LinkedIn](https://www.linkedin.com/in/cristianFortunaReis)