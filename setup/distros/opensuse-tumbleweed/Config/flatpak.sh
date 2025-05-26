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

    game_apps=("com.github.Matoking.protontricks" "com.valvesoftware.Steam" "net.lutris.Lutris" "com.heroicgameslauncher.hgl" "com.usebottles.bottles")
    game_dirs=("/mnt" "/run/media" "~/Games")
    
    for app in "${game_apps[@]}"; do
      for dir in "${game_dirs[@]}"; do
        flatpak_user_override "$dir" "$app"
      done
    done

    flatpak_user_override /.var/me
    mkdir -p ~/.var/me

    SUDO flatpak override --device=dri org.prismlauncher.PrismLauncher
    
    if ! isWsl; then
        # Discord Rich Presence
        for i in {0..9}; do flatpak_user_override xdg-run/discord-ipc-$i; done
    fi

    etc_os_release=$(md5sum /etc/os-release)
    my_os_release=$(md5sum "$HOME/.var/me/os-release")

        if [ ! -f "$HOME/.var/me/os-release" ] || [ "$etc_os_release" != "$my_os_release" ]; then 
            cp -f /etc/os-release "/$HOME/.var/me/os-release"
        fi
fi