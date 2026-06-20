#!/usr/bin/env bash
# Process/2_dnf.sh — DNF5 installation and configuration
set -euo pipefail

# Install dnf5 and related packages via zypper
sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l dnf5 libdnf-repo-config-zypp
sudo dnf5 makecache -y && sudo zypper --gpg-auto-import-keys refresh

# Add protect_running_kernel setting to /etc/dnf/dnf.conf
if grep -q "protect_running_kernel" /etc/dnf/dnf.conf; then
	color_echo Yellow "$(printf "$(_ "⚠️  Warning: %s value is present, skipping.")" "protect_running_kernel")"
else
	echo "protect_running_kernel=False" | sudo tee -a /etc/dnf/dnf.conf >/dev/null
fi

sudo dnf5 versionlock exclude suse-prime
