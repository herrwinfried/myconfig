#!/bin/bash

Packages="e2fsprogs net-tools util-linux"
if CheckWsl; then
Packages+=" humanity-icon-theme materia-gtk-theme gnome-tweaks qt6ct"
Packages+=" lmesa-libOSMesa glib2 minizip pcre2 nautilus"
fi

if lspci | grep -iq "vga.*intel"; then
Packages+=" intel-gpu-tools intel-media-driver"
fi

if ! CheckWsl; then
SUDO dnf swap -y ffmpeg-free ffmpeg --allowerasing
SUDO dnf update -y @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
fi

SUDO $Package $PackageInstall $Packages