#!/bin/bash
if [ -x "$(command -v flatpak)" ]; then
    flatpak --user override --filesystem=$HomePWD/.local/share/themes
    flatpak --user override --filesystem=$HomePWD/.local/share/icons
    flatpak --user override --filesystem=$HomePWD/.local/share/fonts
    flatpak --user override --filesystem=$HomePWD/.local/share/applications
    flatpak --user override --filesystem=$HomePWD/.fonts
    flatpak --user override --env GTK_THEME=Breeze
    $SUDO flatpak override --env GTK_THEME=Breeze


    flatpak override --user --filesystem=xdg-config/MangoHud:ro com.valvesoftware.Steam
    flatpak override --user --filesystem=~/.var/me
    mkdir -p ~/.var/me
    etc_os_release=$(md5sum /etc/os-release)
    my_os_release=$(md5sum "$HOME/.var/me/os-release")
    if [ "$etc_os_release" != "$my_os_release" ]; then
    cp -f /etc/os-release "$HOME/.var/me/os-release"
    fi
else
    echo $red"NOT FOUND flatpak$white"
fi
