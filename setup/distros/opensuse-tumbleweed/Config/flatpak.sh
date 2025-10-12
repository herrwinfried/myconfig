#!/bin/bash

if is_command flatpak; then

    flatpakOverrideFs true ~/.local/share/themes
    flatpakOverrideFs true ~/.local/share/icons
    flatpakOverrideFs true xdg-config/gtk-2.0
    flatpakOverrideFs true xdg-config/gtk-3.0
    flatpakOverrideFs true xdg-config/gtk-4.0
    flatpakOverrideFs true xdg-config/gtk-2.0
    flatpakOverrideFs true xdg-config/gtkrc

    flatpakOverrideFs true xdg-config/MangoHud
    flatpakOverrideFs true ~/.var/me

    game_apps=("com.github.Matoking.protontricks" "com.valvesoftware.Steam" "net.lutris.Lutris" "com.heroicgameslauncher.hgl" "com.usebottles.bottles")
    game_dirs=("/mnt" "/run/media" "$HOME/Games")
    
    for app in "${game_apps[@]}"; do
      for dir in "${game_dirs[@]}"; do
        flatpakOverrideFs true "$dir" "$app"
      done
    done

    flatpakOverrideFs true /.var/me
    CreateDirectory ~/.var/me

    SUDO flatpak override --device=dri org.prismlauncher.PrismLauncher
    
    if ! isWsl; then
        # Discord Rich Presence
        for i in {0..9}; do flatpakOverrideFs true xdg-run/discord-ipc-$i; done
    fi

    etc_os_release=$(md5sum /etc/os-release)
    my_os_release=$(md5sum "$HOME/.var/me/os-release")

        if [ ! -f "$HOME/.var/me/os-release" ] || [ "$etc_os_release" != "$my_os_release" ]; then 
            cp -f /etc/os-release "/$HOME/.var/me/os-release"
        fi
fi