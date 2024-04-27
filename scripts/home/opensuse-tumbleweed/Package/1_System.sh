#!/bin/bash

Packman="ffmpeg $(echo gstreamer-plugins-{good,bad,ugly,libav}) libavcodec-full"
Packages="net-tools"
if CheckWsl; then
Packages+=" humanity-icon-theme materia-gtk-theme gnome-tweaks qt6ct"
Packages+=" libOSMesa8 libgthread-2_0-0 libminizip1 libpcre2-16-0 nautilus"
else
Packman+=" vlc-codecs"
Packages+=" systemd-zram-service intel-gpu-tools"
fi

if CheckWsl; then
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l -R --recommends patterns-wsl-base patterns-wsl-gui patterns-wsl-systemd
fi

SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l -R --from packman-essentials $Packman
SUDO $Package $PackageInstall $Packages