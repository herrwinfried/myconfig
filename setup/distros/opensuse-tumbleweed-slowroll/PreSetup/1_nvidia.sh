#!/bin/bash

if ! isWsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
    #   nvidia-driver-G06-kmp-default == Proprietary kernel modules
    #   nvidia-open-driver-G06-signed-kmp-default == Open GPU kernel modules
        SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l nvidia-open-driver-G06-signed-kmp-default \
        nvidia-video-G06 nvidia-compute-G06 nvidia-gl-G06 nvidia-compute-utils-G06 \
        nvidia-video-G06-32bit nvidia-gl-G06-32bit nvidia-compute-G06-32bit
    fi
    SUDO groupadd wheel
    SUDO usermod -aG wheel $USER

fi