#!/usr/bin/env bash
# Presetup/1_nvidia.sh — NVIDIA driver installation + wheel group
set -euo pipefail

# Install drivers if an NVIDIA GPU is detected
if lspci | grep -qi -E "nvidia|NVIDIA"; then
	sudo zypper --gpg-auto-import-keys --no-gpg-checks in -y -l nvidia-open-driver-G07 \
		$(echo nvidia-video-G07{,-32bit}) \
		$(echo nvidia-compute-G07{,-32bit}) \
		$(echo nvidia-gl-G07{,-32bit}) nvidia-compute-utils-G07 nvidia-settings
	sudo zypper --gpg-auto-import-keys --no-gpg-checks al nvidia\*G0\*kmp\*
	sudo mokutil --import /var/lib/dkms/mok.pub --root-pw
fi

# Ensure the wheel group exists
if ! getent group wheel >/dev/null; then
	sudo groupadd wheel
fi
sudo usermod -aG wheel "$USER"