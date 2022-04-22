#!/bin/bash

if [ -f "/Library/Fonts/MesloLGS NF Bold Italic.ttf" ]; then
sudo rm -rf /Library/Fonts/MesloLGS NF Bold Italic.ttf
fi

if [ -f "/Library/Fonts/MesloLGS NF Bold.ttf" ]; then
sudo rm -rf /Library/Fonts/MesloLGS NF Bold.ttf
fi

if [ -f "/Library/Fonts/MesloLGS NF Italic.ttf" ]; then
sudo rm -rf /Library/Fonts/MesloLGS NF Italic.ttf
fi

if [ -f "/Library/Fonts/MesloLGS NF Regular.ttf" ]; then
sudo rm -rf /Library/Fonts/MesloLGS NF Regular.ttf
fi
##### WGET
if [ ! -f "/Library/Fonts/MesloLGS NF Bold Italic.ttf" ]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /Library/Fonts
fi

if [ ! -f "/Library/Fonts/MesloLGS NF Bold.ttf" ]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /Library/Fonts
fi

if [ ! -f "/Library/Fonts/MesloLGS NF Italic.ttf" ]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /Library/Fonts
fi

if [ ! -f "/Library/Fonts/MesloLGS NF Regular.ttf" ]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /Library/Fonts
fi