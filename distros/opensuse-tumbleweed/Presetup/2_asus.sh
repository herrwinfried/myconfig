#!/usr/bin/env bash
# Presetup/2_asus.sh — ASUS laptop support
set -euo pipefail

if [[ "${config[boardVendor]}" == *"asus"* ]]; then
	sudo zypper --gpg-auto-import-keys --no-gpg-checks rm -y suse-prime tlp
	sudo zypper --gpg-auto-import-keys --no-gpg-checks al suse-prime
	sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l \
		power-profiles-daemon asusctl supergfxctl asusctl-rog-gui
	sudo systemctl enable --now supergfxd.service
	sudo systemctl enable --now asusd.service
fi
