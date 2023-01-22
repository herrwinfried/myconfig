#!/bin/bash

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then
sudo zypper install --recommends -y patterns-wsl-base patterns-wsl-gui patterns-wsl-systemd

sudo $PackageName $PackageInstall noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme materia-gtk-theme gnome-tweaks qt5ct \
Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0 \
Mesa-libva
fi