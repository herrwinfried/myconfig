#!/bin/bash

if [ -x "$(command -v flatpak)" ]; then

    flatpak_user_override ~/.local/share/themes
    flatpak_user_override ~/.local/share/icons
    flatpak_user_override xdg-config/gtk-2.0
    flatpak_user_override xdg-config/gtk-3.0
    flatpak_user_override xdg-config/gtk-4.0
    flatpak_user_override xdg-config/gtk-2.0
    flatpak_user_override xdg-config/gtkrc

    flatpak_user_override xdg-config/MangoHud
    flatpak_user_override ~/.var/me

    flatpak_user_override /mnt com.github.Matoking.protontricks
    flatpak_user_override /run/media com.github.Matoking.protontricks
    flatpak_user_override ~/Games com.github.Matoking.protontricks

    flatpak_user_override /mnt com.valvesoftware.Steam
    flatpak_user_override /run/media com.valvesoftware.Steam
    flatpak_user_override ~/Games com.valvesoftware.Steam

    flatpak_user_override /mnt net.lutris.Lutris
    flatpak_user_override /run/media net.lutris.Lutris
    flatpak_user_override ~/Games net.lutris.Lutris

    flatpak_user_override /mnt com.heroicgameslauncher.hgl
    flatpak_user_override /run/media com.heroicgameslauncher.hgl
    flatpak_user_override ~/Games com.heroicgameslauncher.hgl

    flatpak_user_override /mnt com.usebottles.bottles
    flatpak_user_override /run/media com.usebottles.bottles
    flatpak_user_override ~/Games com.usebottles.bottles

    flatpak_user_override /.var/me
    mkdir -p ~/.var/me

    SUDO flatpak override --device=dri org.prismlauncher.PrismLauncher
    
    if ! checkwsl; then
        # Discord Rich Presence
        for i in {0..9}; do flatpak_user_override xdg-run/discord-ipc-$i; done
    fi

    etc_os_release=$(md5sum /etc/os-release)
    my_os_release=$(md5sum "$USERHOME/.var/me/os-release")

        if [ ! -f "$USERHOME/.var/me/os-release" ] || [ "$etc_os_release" != "$my_os_release" ]; then 
            cp -f /etc/os-release "$USERHOME/.var/me/os-release"
        fi
fi
