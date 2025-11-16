#!/bin/bash
Packman=(ffmpeg $(echo gstreamer-plugins-{good,bad,ugly,libav}) libavcodec-full)
System=(e2fsprogs net-tools util-linux-systemd gcc rsync tar ruby which)

if isWsl; then
System+=(qt6ct libgthread-2_0-0 libminizip1 libpcre2-16-0 nautilus) 
else
Packman+=(vlc-codecs)
System+=(systemd-zram-service $(echo kernel-{source,devel,longterm-devel,source-longterm}))
fi

if inxi -G | grep -iq "intel"; then
System+=(intel-gpu-tools)
fi

if isWsl; then
SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l --recommends $(echo patterns-wsl-{base,gui,systemd,tmpfiles})
fi

SUDO zypper dup -y -l --from packman-essentials --allow-vendor-change
SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l --from packman-essentials "${Packman[@]}"
SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l "${System[@]}"