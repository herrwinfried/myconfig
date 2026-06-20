#!/usr/bin/env bash
# Configure/hostname.sh — Set the computer name
set -euo pipefail

if [[ "$(hostname)" == "${config[hostname]}" ]]; then
	echo "$(_ "Hostname is already set correctly, skipping.")"
else
	sudo hostnamectl set-hostname "${config[hostname]}" || {
		echo "${config[hostname]}" | sudo tee /etc/hostname >/dev/null
	}
fi