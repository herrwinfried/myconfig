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
fi