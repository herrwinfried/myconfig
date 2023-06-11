#!/bin/bash

Packman0="ffmpeg $(echo gstreamer-plugins-{good,bad,ugly,libav}) libavcodec-full"

if checkwsl ; then

sudo $Package $PackageInstall --from packman-essentials $Packman0
sudo $Package $PackageInstall --recommends patterns-wsl-base patterns-wsl-gui patterns-wsl-systemd
sudo $Package $PackageInstall noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme materia-gtk-theme gnome-tweaks qt5ct \
Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0 \
Mesa-libva busybox-net-tools
else 

sudo $Package $PackageInstall --from packman-essentials $Packman0 vlc-codecs intel-gpu-tools

sudo $Package $PackageInstall systemd-zram-service busybox-net-tools

sudo systemctl enable zramswap.service nvidia-{hibernate,suspend,resume}.service
fi
