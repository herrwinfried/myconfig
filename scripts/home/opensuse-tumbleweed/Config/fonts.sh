#!/bin/bash

if ! CheckWsl; then

FONT_DIR="/usr/local/share/fonts/truetype"
MESLO_URL=$(curl -s "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest" | jq -r ".assets[] | select(.name | test(\"Meslo.zip\")) | .browser_download_url")

WindowsDiskPath="/run/media/$USER/OS"
WINDOWS_FONT_DIR="$WindowsDiskPath/Windows/Fonts/"

test -d "/tmp/Meslo.zip" && SUDO rm -rf "/tmp/Meslo.zip"
test -d "$FONT_DIR/Meslo" && SUDO rm -rf "$FONT_DIR/Meslo"
sleep 3; curl -L "$MESLO_URL" -o /tmp/Meslo.zip
SUDO mkdir -p "$FONT_DIR/Meslo"
SUDO unzip "/tmp/Meslo.zip" -d "$FONT_DIR/Meslo"

SUDO mkdir -p "$FONT_DIR/WindowsFonts"
if [ -d "$WINDOWS_FONT_DIR" ]; then
SUDO find "$WINDOWS_FONT_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp -f {} "$FONT_DIR/WindowsFonts" \;
else
echo -e "${Red}The directory was not found, so the operation was not completed.  (${WINDOWS_FONT_DIR}) ${NoColor}"
fi 

fc-cache -f -v
SUDO fc-cache -f -v

fi