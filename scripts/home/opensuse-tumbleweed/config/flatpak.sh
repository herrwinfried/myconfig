#!/bin/bash

if [ -x "$(command -v flatpak)" ]; then

    flatpak_user_override .local/share/themes
    flatpak_user_override .local/share/icons
    flatpak_user_override .local/share/fonts
    flatpak_user_override .local/share/applications
    flatpak_user_override .fonts
    flatpak_user_override .config/gtk-3.0
    flatpak_user_override .config/gtk-4.0
    flatpak_user_override .config/gtkrc
    flatpak_user_override .config/MangoHud
    flatpak_user_override .var/app/com.valvesoftware.Steam/config/MangoHud/MangoHud.conf
    flatpak_user_override .var/app/com.valvesoftware.Steam/config/MangoHud
    flatpak_user_override .var/app/com.valvesoftware.Steam/config

    SUDO flatpak override --env GTK_THEME=Adwaita-dark

    ln -sf $USERHOME/.var/app/com.valvesoftware.Steam/config/MangoHud/MangoHud.conf $USERHOME/.config/MangoHud/MangoHud.conf

    flatpak_user_override .var/app/com.valvesoftware.Steam/config/MangoHud/MangoHud.conf com.valvesoftware.Steam
    flatpak_user_override /mnt com.valvesoftware.Steam
    flatpak_user_override /mnt net.lutris.Lutris
    flatpak_user_override /run/media com.valvesoftware.Steam
    flatpak_user_override /run/media net.lutris.Lutris

    flatpak_user_override /.var/me
    mkdir -p ~/.var/me

    etc_os_release=$(md5sum /etc/os-release)
    my_os_release=$(md5sum "$USERHOME/.var/me/os-release")

        if [ ! -f "$USERHOME/.var/me/os-release" ] || [ "$etc_os_release" != "$my_os_release" ]; then 
            cp -f /etc/os-release "$USERHOME/.var/me/os-release"
        fi
fi
