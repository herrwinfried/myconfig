#!/usr/bin/env bash
# Configure/zram.sh — Enable ZRAM swap space
set -euo pipefail

if rpm -q systemd-zram-service &>/dev/null; then
	if [[ -f /usr/lib/systemd/system/zramswap.service ]]; then
		sudo systemctl enable --now zramswap
	fi
fi