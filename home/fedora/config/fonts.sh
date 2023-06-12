#!/bin/bash

if [[ -f "/usr/share/fonts/truetype/MesloLGS NF Bold Italic.ttf" ]]; then
    sudo rm -rf /usr/share/fonts/truetype/MesloLGS NF Bold Italic.ttf
fi

if [[ -f "/usr/share/fonts/truetype/MesloLGS NF Bold.ttf" ]]; then
    sudo rm -rf /usr/share/fonts/truetype/MesloLGS NF Bold.ttf
fi

if [[ -f "/usr/share/fonts/truetype/MesloLGS NF Italic.ttf" ]]; then
    sudo rm -rf /usr/share/fonts/truetype/MesloLGS NF Italic.ttf
fi

if [[ -f "/usr/share/fonts/truetype/MesloLGS NF Regular.ttf" ]]; then
    sudo rm -rf /usr/share/fonts/truetype/MesloLGS NF Regular.ttf
fi
##### WGET
if [[ ! -f "/usr/share/fonts/truetype/MesloLGS NF Bold Italic.ttf" ]]; then
    sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /usr/share/fonts/truetype
fi

if [[ ! -f "/usr/share/fonts/truetype/MesloLGS NF Bold.ttf" ]]; then
    sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /usr/share/fonts/truetype
fi

if [[ ! -f "/usr/share/fonts/truetype/MesloLGS NF Italic.ttf" ]]; then
    sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /usr/share/fonts/truetype
fi

if [[ ! -f "/usr/share/fonts/truetype/MesloLGS NF Regular.ttf" ]]; then
    sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /usr/share/fonts/truetype
fi

fc-cache
