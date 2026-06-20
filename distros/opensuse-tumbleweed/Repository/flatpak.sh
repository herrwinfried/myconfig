#!/usr/bin/env bash
# Repository/flatpak.sh — Flatpak installation and repository addition
set -euo pipefail

sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l "flatpak"

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak remote-add --if-not-exists flathub-beta https://flathub.org/beta-repo/flathub-beta.flatpakrepo