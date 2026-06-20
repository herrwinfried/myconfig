#!/usr/bin/env bash
# Configure/cockpit.sh — Cockpit web management panel
set -euo pipefail

if systemctl list-unit-files cockpit.socket &>/dev/null; then
	sudo systemctl enable --now cockpit.socket
fi