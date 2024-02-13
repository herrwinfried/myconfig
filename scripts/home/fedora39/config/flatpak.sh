#!/bin/bash
if [ -x "$(command -v flatpak)" ]; then
    flatpak --user override --filesystem=$HomePWD/.local/share/themes
    flatpak --user override --filesystem=$HomePWD/.local/share/icons
    flatpak --user override --filesystem=$HomePWD/.local/share/fonts
    flatpak --user override --filesystem=$HomePWD/.local/share/applications
    flatpak --user override --filesystem=$HomePWD/.fonts
    flatpak --user override --filesystem=$HomePWD/.config/gtk-3.0
    flatpak --user override --filesystem=$HomePWD/.config/gtk-4.0
    flatpak --user override --filesystem=$HomePWD/.config/gtkrc
    flatpak --user override --filesystem=xdg-config/MangoHud:ro
    flatpak --user override --filesystem=$HomePWD/.config/MangoHud
    flatpak --user override --env GTK_THEME=Adwaita-dark
    SUDO flatpak override --env GTK_THEME=Adwaita-dark


    ln -s $HomePWD/.var/app/com.valvesoftware.Steam/config/MangoHud/MangoHud.conf $HomePWD/.config/MangoHud/MangoHud.conf
    flatpak --user override --filesystem=$HomePWD/.var/app/com.valvesoftware.Steam/config/MangoHud/MangoHud.conf com.valvesoftware.Steam
    flatpak --user override --filesystem=/mnt com.valvesoftware.Steam
    flatpak --user override --filesystem=/mnt net.lutris.Lutris
    flatpak --user override --filesystem=/run/media com.valvesoftware.Steam
    flatpak --user override --filesystem=/run/media net.lutris.Lutris
    
    flatpak override --user --filesystem=~/.var/me
    mkdir -p ~/.var/me
    etc_os_release=$(md5sum /etc/os-release)
    if [ ! -f "$HomePWD/.var/me/os-release" ]; then 
        touch "$HomePWD/.var/me/os-release"
    fi
    my_os_release=$(md5sum "$HomePWD/.var/me/os-release")
    if [ "$etc_os_release" != "$my_os_release" ]; then
    cp -f /etc/os-release "$HomePWD/.var/me/os-release"
    fi
else
    echo $red"NOT FOUND flatpak$white"
fi
