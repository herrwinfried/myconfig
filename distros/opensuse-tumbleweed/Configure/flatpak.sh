#!/usr/bin/env bash
# Configure/flatpak.sh — Flatpak permission override configuration
set -euo pipefail

if is_command flatpak; then
	# GTK theme and icon access
	flatpakOverrideFs true ~/.local/share/themes
	flatpakOverrideFs true ~/.local/share/icons
	flatpakOverrideFs true xdg-config/gtk-2.0
	flatpakOverrideFs true xdg-config/gtk-3.0
	flatpakOverrideFs true xdg-config/gtk-4.0
	flatpakOverrideFs true xdg-config/gtkrc

	# MangoHud configuration
	flatpakOverrideFs true xdg-config/MangoHud

	# Game applications — access to storage areas
	local -a game_apps=(
		"com.github.Matoking.protontricks"
		"com.valvesoftware.Steam"
		"net.lutris.Lutris"
		"com.heroicgameslauncher.hgl"
		"com.usebottles.bottles"
	)
	local -a game_dirs=("/mnt" "/run/media" "$HOME/Games")

	for app in "${game_apps[@]}"; do
		for dir in "${game_dirs[@]}"; do
			flatpakOverrideFs true "$dir" "$app"
		done
	done

	# PrismLauncher DRI access
	sudo flatpak override --device=dri org.prismlauncher.PrismLauncher

	# Discord Rich Presence
	for i in {0..9}; do
		flatpakOverrideFs true "xdg-run/discord-ipc-$i"
	done
fi