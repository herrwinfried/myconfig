#!/bin/bash

FONT_DIR="/usr/local/share/fonts/truetype"
MESLO_FONT_NAMES=("MesloLGS NF Bold Italic" "MesloLGS NF Bold" "MesloLGS NF Italic" "MesloLGS NF Regular")

WindowsDiskPath="/run/media/$USER/OS"
WINDOWS_FONT_DIR="$WindowsDiskPath/Windows/Fonts/"

for font_name in "${MESLO_FONT_NAMES[@]}"; do
    font_file="${FONT_DIR}/${font_name}.ttf"
    if [[ -f "$font_file" ]]; then
        SUDO rm -rf "$font_file"
    fi

    if [[ ! -f "$font_file" ]]; then
        SUDO wget "https://github.com/romkatv/powerlevel10k-media/raw/master/${font_name// /%20}.ttf" -P "$FONT_DIR"
    fi
done

SUDO mkdir -p "$FONT_DIR/WindowsFonts"
if [ -d "$WINDOWS_FONT_DIR" ]; then
SUDO find "$WINDOWS_FONT_DIR" -type f \( -name "*.ttf" -o -name "*.otf" \) -exec cp -f {} "$FONT_DIR/WindowsFonts" \;
else
echo -e "${Red}The directory was not found, so the operation was not completed.  (${WINDOWS_FONT_DIR}) ${NoColor}"
exit
fi 

fc-cache -f -v
SUDO fc-cache -f -v
