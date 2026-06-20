#!/usr/bin/env bash
# Configure/directory.sh — Copy data files to system directories
set -euo pipefail

# Calculate project root (Configure → distro → distros → project_root)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATA_DIR="$(cd "${SCRIPT_DIR}/../../.." && pwd)/data"

echo "$(_ "Data directory resolved to:") ${DATA_DIR}"

# Verify required subdirectories exist
if [[ ! -d "${DATA_DIR}/root" ]] || [[ ! -d "${DATA_DIR}/user" ]] || [[ ! -d "${DATA_DIR}/superuser" ]]; then
	color_echo Red "$(printf "$(_ "❌ One or more required data subdirectories are missing in %s.")" "$DATA_DIR")"
	exit 1
fi

# data/root → system root (/)
# Copy data/root to system root (/)

echo "$(_ "Copying data/root to / ...")"
sudo cp -a --no-preserve=all "${DATA_DIR}/root/." /

# Copy data/user to user home directory

echo "$(printf "$(_ "Copying data/user to %s ...")" "$HOME")"
cp -a "${DATA_DIR}/user/." "$HOME/"

# Copy data/superuser to root home directory (/root)

echo "$(_ "Copying data/superuser to /root ...")"
sudo cp -a --no-preserve=all "${DATA_DIR}/superuser/." /root/

echo "$(_ "Copying data/root_wsl to / ...")"
sudo cp -a --no-preserve=all "${DATA_DIR}/root_wsl/." /

color_echo Green "$(_ "✅ All data has been copied successfully.")"
