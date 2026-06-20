#!/usr/bin/env bash
# Process/1_System.sh — System and codec packages
set -euo pipefail

Packman=(ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full)
System=(e2fsprogs net-tools util-linux-systemd gcc rsync tar ruby which git qt6ct libgthread-2_0-0 libminizip1 libpcre2-16-0 nautilus patterns-wsl-{base,gui,systemd,tmpfiles})


sudo zypper --gpg-auto-import-keys --no-gpg-checks dup -y -l --from packman-essentials --allow-vendor-change
sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l --from packman-essentials "${Packman[@]}"
sudo zypper --gpg-auto-import-keys --no-gpg-checks install -y -l "${System[@]}"
