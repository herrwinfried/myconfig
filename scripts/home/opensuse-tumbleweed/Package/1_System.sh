#!/bin/bash

packman0="ffmpeg $(echo gstreamer-plugins-{good,bad,ugly,libav}) libavcodec-full"
package_a="net-tools"
if checkwsl; then
    package_a+=" noto-sans-fonts gsettings-desktop-schemas libwayland-client0 libwayland-cursor0 libwayland-server0 xwayland humanity-icon-theme materia-gtk-theme gnome-tweaks qt5ct"
    package_a+=" Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0 Mesa-libva"
    package_a+=" nautilus "
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l -R --from packman-essentials $packman0
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l -R --recommends patterns-wsl-base patterns-wsl-gui patterns-wsl-systemd
else
    SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l -R --from packman-essentials $packman0 vlc-codecs
    package_a+=" systemd-zram-service intel-gpu-tools"
fi

SUDO $Package $PackageInstall $package_a