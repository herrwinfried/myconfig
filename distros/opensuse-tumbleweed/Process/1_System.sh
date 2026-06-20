#!/usr/bin/env bash
# Process/1_System.sh — System and codec packages
set -euo pipefail

Packman=(ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs)
System=(e2fsprogs net-tools util-linux-systemd gcc rsync tar ruby which systemd-zram-service kernel-{source,devel,longterm-devel,source-longterm} git)

if inxi -G | grep -iq "intel"; then
	System+=(intel-gpu-tools)
fi

sudo zypper --gpg-auto-import-keys --no-gpg-checks dup -y -l --from packman-essentials --allow-vendor-change
sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l --from packman-essentials "${Packman[@]}"
sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l "${System[@]}"
