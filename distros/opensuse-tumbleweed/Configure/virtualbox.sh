#!/usr/bin/env bash
set -euo pipefail

	if rpm -q virtualbox &> /dev/null; then
		sudo groupadd -f vboxusers
		sudo usermod -aG vboxusers "$USER"
	fi



