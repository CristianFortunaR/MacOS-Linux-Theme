#!/bin/bash

echo "Updating packages and installing tools"
sudo apt update -y
sudo apt upgrade -y

# Installing gnome packages
echo "installing gnome-tweaks"
sudo apt install wget curl git sassc gnome-tweaks gnome-shell-extension-manager
echo "gnome installed"


#Flatpack
echo "installing Flatpak and adding flathub repo"
sudo apt install flatpak -y
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
echo "Flatpak installed and repo added"


# install icons from https://www.pling.com/p/1102582/
eco "Installing Cupertino Sonoma Icons..."
ICON_REPO_URL="https://github.com/USBA/Cupertino-Sonoma-iCons.git"
ICON_TEMP_DIR="$HOME/Downloads/Cupertino-Sonoma-iCons"
echo "Cloning Icon repo to  $ICON_TEMP_DIR..."
git clone $ICON_REPO_URL $ICON_TEMP_DIR
echo "Copying icons to ~/.icons/..."
mkdir -p "$HOME/.icons/"
cp -r "$ICON_TEMP_DIR/Theme" "$HOME/.icons/Cupertino Sonoma iCons" #Copy 'Theme' Folder and rename it
echo "Icon theme copied to ~/.icons/Cupertino Sonoma iCons."

# IMPORTANT, THIS INFORM THE SYSTEM THAT NEW ICONS HAVE BEING ADDED
echo "Updating icons cache..."
gtk-update-icon-cache -f -t "$HOME/.icons/Cupertino Sonoma iCons"
echo "Cache de ícones atualizado."

echo "Appying icon theme 'Cupertino Sonoma iCons' to the system..."
gsettings set org.gnome.desktop.interface icon-theme "Cupertino Sonoma iCons"
echo "icon themes applied."


# Installing Theme GTK (WhiteSur-gtk-theme)
echo "Starting Installing theme 'GTK WhiteSur-gtk-theme'..."


THEME_REPO_URL="https://github.com/vinceliuice/WhiteSur-gtk-theme.git"
THEME_TEMP_DIR="$HOME/Downloads/WhiteSur-gtk-theme"

echo "Cloning theme repo to $THEME_TEMP_DIR..."
git clone $THEME_REPO_URL --depth=1 $THEME_TEMP_DIR

echo "Executing installing script of theme WhiteSur-gtk-theme..."
cd "$THEME_TEMP_DIR"
./install.sh -t all -c Dark -m -b # Installing everything to a simple installation ./install.sh

#tweaks
echo "Aplicando tweaks adicionais do tema WhiteSur (Firefox e GNOME Shell)..."
# -F -f: Tweaks to Firefox (F) and context painel (f)
sudo ./tweaks.sh -F -f
# -g: Tweaks to GNOME Shell
sudo ./tweaks.sh -g

# Back to home dir
cd "$HOME"
echo "WhiteSur-gtk-theme finished."

# the 'gsettings' is used to define standard theme of the system.
# the theme name should match the name that script 'install.sh' register.
# can be "WhiteSur-Dark" or "WhiteSur-Light" is of your choice.
echo "Aplicando o tema GTK 'WhiteSur-Dark' no sistema..."
gsettings set org.gnome.desktop.interface gtk-theme "WhiteSur-Dark" # you can change for the variant that you have installed.
echo "Theme Applied."

## installing and adding extensions Gnome shell

echo "Starting of installation extensions GNOME Shell..."

install_and_enable_gnome_extension() {
    EXTENSION_NAME="$1"
    EXTENSION_ID="$2"   
    EXTENSION_URL="$3"  
    EXTENSION_DIR_NAME="$4"

    echo "--- Processing: $EXTENSION_NAME (ID: $EXTENSION_ID) ---"

    DOWNLOAD_PATH="$HOME/Downloads/${EXTENSION_NAME// /-}.zip" # convert space to -
    INSTALL_PATH="$HOME/.local/share/gnome-shell/extensions/$EXTENSION_DIR_NAME"

    echo "Downloading $EXTENSION_NAME of $EXTENSION_URL..."
    wget -O "$DOWNLOAD_PATH" "$EXTENSION_URL" || { echo "error in download $EXTENSION_NAME. Skipping..."; return 1; }

    echo "unpacking $EXTENSION_NAME to $INSTALL_PATH..."
    mkdir -p "$INSTALL_PATH" 
    unzip -o "$DOWNLOAD_PATH" -d "$INSTALL_PATH" || { echo "Error in unpacking $EXTENSION_NAME. Skipping..."; return 1; }
    echo "Extension unpacked."

    # Enable extension
    CURRENT_ENABLED_EXTENSIONS=$(gsettings get org.gnome.shell enabled-extensions)

    # Validate if extensions is on the list otherwise enable
    if ! echo "$CURRENT_ENABLED_EXTENSIONS" | grep -q "'$EXTENSION_DIR_NAME'"; then
        
        NEW_ENABLED_EXTENSIONS=$(echo "$CURRENT_ENABLED_EXTENSIONS" | sed "s/]$/, '$EXTENSION_DIR_NAME']/")
        gsettings set org.gnome.shell enabled-extensions "$NEW_ENABLED_EXTENSIONS"
        echo "$EXTENSION_NAME enabled."
    else
        echo "$EXTENSION_NAME already enabled."
    fi

    #remove zip after enabled, clean your pc, comment this if you dont want to remove
    rm "$DOWNLOAD_PATH"
    echo "ZIP Archive of $EXTENSION_NAME removed."

    echo "--- $EXTENSION_NAME finished. ---"
    echo ""
}


install_and_enable_gnome_extension \
    "Blur My Shell" \
    "3193" \
    "https://extensions.gnome.org/extension-data/blur-my-shellmaimi.github.com/blur-my-shell-3193.v46.shell-extension.zip" \
    "blur-my-shell@aunetx"

install_and_enable_gnome_extension \
    "User Themes" \
    "19" \
    "https://extensions.gnome.org/extension-data/user-themegnome-shell-extensions.gcampax.github.com/user-theme-19.v46.shell-extension.zip" \
    "user-theme@gnome-shell-extensions.gcampax.github.com"

install_and_enable_gnome_extension \
    "Search Light" \
    "4945" \
    "https://extensions.gnome.org/extension-data/search-lightcinnamon.romainferes.github.com/search-light-4945.v46.shell-extension.zip" \
    "search-light@cinnamon.romainferes.github.com"

install_and_enable_gnome_extension \
    "GNOME 4x UI Improvements" \
    "4158" \
    "https://extensions.gnome.org/extension-data/gnome-4x-ui-improvementsdimka665.github.com/gnome-4x-ui-improvements-4158.v46.shell-extension.zip" \
    "gnome-4x-ui-improvements@dimka665.github.com"

install_and_enable_gnome_extension \
    "Media Control" \
    "3959" \
    "https://extensions.gnome.org/extension-data/media-controlgnome-shell-extensions.gcampax.github.com/media-control-3959.v46.shell-extension.zip" \
    "media-control@gnome-shell-extensions.gcampax.github.com"


echo "installation and enablement of all extensions finished!"
echo "In order to all extensions work, you need to restart Gnome Shell (Alt + F2, r, Enter) or logout and login again."

echo "Installing plank and cofiguring the dock..."

sudo apt install -y plank
echo "Plank installed."

AUTOSTART_DIR="$HOME/.config/autostart"
PLANK_DESKTOP_FILE="$AUTOSTART_DIR/plank.desktop"

mkdir -p "$AUTOSTART_DIR"

if [ ! -f "$PLANK_DESKTOP_FILE" ]; then
    echo "Adding plank to autostart..."
    echo "[Desktop Entry]" > "$PLANK_DESKTOP_FILE"
    echo "Type=Application" >> "$PLANK_DESKTOP_FILE"
    echo "Exec=plank" >> "$PLANK_DESKTOP_FILE"
    echo "Hidden=false" >> "$PLANK_DESKTOP_FILE"
    echo "NoDisplay=false" >> "$PLANK_DESKTOP_FILE"
    echo "X-GNOME-Autostart-enabled=true" >> "$PLANK_DESKTOP_FILE"
    echo "Name=Plank" >> "$PLANK_DESKTOP_FILE"
    echo "Comment=Lightweight dock" >> "$PLANK_DESKTOP_FILE"
    echo "Icon=plank" >> "$PLANK_DESKTOP_FILE"
    echo "plank added to autostart."
else
    echo "plank confifured."
fi

echo "Applying initial setup for plank..."
dconf write /net/launchpad/plank/docks/dock1/hide-mode "'intelli-hide'"
dconf write /net/launchpad/plank/docks/dock1/position "'bottom'"
# example: icon size (ajust as you preferred)
dconf write /net/launchpad/plank/docks/dock1/icon-size "48"
echo "Planmk configuration applied."

echo "Installation and enablement of Plank finished!"

echo "Customization ended! please restart in order to apply all configurations."