#!/usr/bin/env bash
# Container configuration: Podman + Distrobox
set -euo pipefail
if is_command podman; then
	# Enable user services for podman
	systemctl --user enable --now podman.service
	systemctl --user enable --now podman.socket
fi

if is_command distrobox && is_command podman; then
	# Set up Distrobox environments
	distrobox_home="$HOME/distrobox"
	mkdir -p "$distrobox_home/home"/{fedora,debian}

	distrobox-create -i fedora:latest -n fedora --nvidia --init \
		-H "$distrobox_home/home/fedora" \
		-ap 'xdg-user-dirs systemd dos2unix' \
		--additional-flags "--env DX_OS=opensuse-tumbleweed"

	distrobox-create -i debian:latest -n debian --nvidia --init \
		-H "$distrobox_home/home/debian" \
		-ap 'xdg-user-dirs systemd libpam-systemd dos2unix' \
		--additional-flags "--env DX_OS=opensuse-tumbleweed"
fi
