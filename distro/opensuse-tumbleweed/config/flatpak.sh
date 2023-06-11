#!/bin/bash
if [ -x "$(command -v flatpak)" ]; then
flatpak --user override --filesystem=$HomePWD/.local/share/themes
flatpak --user override --filesystem=$HomePWD/.local/share/icons
flatpak --user override --filesystem=$HomePWD/.local/share/fonts
flatpak --user override --filesystem=$HomePWD/.local/share/applications
flatpak --user override --filesystem=$HomePWD/.fonts
flatpak --user override --env GTK_THEME=Adwaita-dark
sudo flatpak override --env GTK_THEME=Adwaita-dark
else 
echo $red"NOT FOUND flatpak$white"
fi
