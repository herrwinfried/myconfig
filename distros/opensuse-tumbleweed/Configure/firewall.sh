#!/usr/bin/env bash
# Configure/firewall.sh — Firewall rules (Stremio, LocalSend)
set -euo pipefail

if is_command firewall-cmd; then
	# Create custom services
	sudo firewall-cmd --permanent --new-service=stremio 2>/dev/null || true
	sudo firewall-cmd --permanent --new-service=localsend 2>/dev/null || true
	
	# Reload so firewalld recognizes the newly created services
	sudo firewall-cmd --reload

	# Configure Stremio
	sudo firewall-cmd --permanent --service=stremio --add-port=11470/tcp
	sudo firewall-cmd --permanent --service=stremio --add-port=12470/tcp
	sudo firewall-cmd --permanent --zone=home --add-service=stremio || true

	# Configure LocalSend
	sudo firewall-cmd --permanent --service=localsend --add-port=53317/tcp
	sudo firewall-cmd --permanent --zone=home --add-service=localsend || true

	# Apply all changes
	sudo firewall-cmd --reload
fi