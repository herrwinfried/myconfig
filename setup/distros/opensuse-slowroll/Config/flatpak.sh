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

    game_apps=("com.github.Matoking.protontricks" "com.valvesoftware.Steam" "net.lutris.Lutris" "com.heroicgameslauncher.hgl" "com.usebottles.bottles")
    game_dirs=("/mnt" "/run/media" "$HOME/Games")
    
    for app in "${game_apps[@]}"; do
      for dir in "${game_dirs[@]}"; do
        flatpakOverrideFs true "$dir" "$app"
      done
    done

    SUDO flatpak override --device=dri org.prismlauncher.PrismLauncher
    
    if ! isWsl; then
        # Discord Rich Presence
        for i in {0..9}; do flatpakOverrideFs true xdg-run/discord-ipc-$i; done
    fi
fi