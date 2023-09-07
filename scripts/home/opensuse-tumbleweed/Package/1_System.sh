#!/bin/bash

Packman0="ffmpeg $(echo gstreamer-plugins-{good,bad,ugly,libav}) libavcodec-full"

if checkwsl; then

    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l -R --from packman-essentials $Packman0
    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l -R --recommends patterns-wsl-base patterns-wsl-gui patterns-wsl-systemd
    $SUDO $Package $PackageInstall noto-sans-fonts gsettings-desktop-schemas xorg-x11 xorg-x11-server humanity-icon-theme materia-gtk-theme gnome-tweaks qt5ct \
        Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0 \
        Mesa-libva net-tools net-tools-deprecated
else

    $SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l -R --from packman-essentials $Packman0 vlc-codecs

    $SUDO $Package $PackageInstall systemd-zram-service net-tools net-tools-deprecated intel-gpu-tools

    $SUDO systemctl enable zramswap.service nvidia-{hibernate,suspend,resume}.service
fi
