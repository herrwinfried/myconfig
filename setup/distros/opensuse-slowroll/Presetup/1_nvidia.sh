#!/bin/bash

if ! isWsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
    #   nvidia-driver-G06-kmp-default == Proprietary kernel modules
    #   nvidia-open-driver-G06-signed-kmp-default == Open GPU kernel modules
    #   nvidia-open-driver-G06-signed-cuda-kmp-default == Open GPU kernel modules for Cuda repository
        SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l $(echo nvidia-open-driver-G06-signed-cuda-kmp-{default,longterm}) \
        $(echo nvidia-video-G06{,-32bit}) $(echo nvidia-compute-G06{,-32bit}) $(echo nvidia-gl-G06{,-32bit})
    fi
    SUDO groupadd wheel
    SUDO usermod -aG wheel $USER

fi
