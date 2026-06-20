#!/usr/bin/env bash
set -euo pipefail

	if is_command nvidia-ctk; then
		sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
		nvidia-ctk runtime configure --runtime=docker --config="$HOME/.config/docker/daemon.json"
		sudo nvidia-ctk config --set nvidia-container-cli.no-cgroups --in-place
		if is_command setsebool; then
			sudo setsebool -P container_use_devices true
		fi
	fi

