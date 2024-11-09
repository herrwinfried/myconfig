#!/bin/bash

FONT_DIR="/usr/share/fonts/truetype"
FONT_NAMES=("MesloLGS NF Bold Italic" "MesloLGS NF Bold" "MesloLGS NF Italic" "MesloLGS NF Regular")

for font_name in "${FONT_NAMES[@]}"; do
    font_file="${FONT_DIR}/${font_name}.ttf"
    if [[ -f "$font_file" ]]; then
        SUDO rm -rf "$font_file"
    fi

    if [[ ! -f "$font_file" ]]; then
        SUDO wget "https://github.com/romkatv/powerlevel10k-media/raw/master/${font_name// /%20}.ttf" -P "$FONT_DIR"
    fi
done

fc-cache
