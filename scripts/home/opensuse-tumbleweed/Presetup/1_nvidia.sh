#!/bin/bash

if ! CheckWsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
    #   nvidia-driver-G06-kmp-default == Proprietary kernel modules
    #   nvidia-open-driver-G06-signed-kmp-default == Open GPU kernel modules
        SUDO $Package $PackageInstall nvidia-open-driver-G06-signed-kmp-default \
        nvidia-drivers-G06 nvidia-video-G06 nvidia-gl-G06 nvidia-compute-G06 \
        nvidia-video-G06-32bit nvidia-gl-G06-32bit nvidia-compute-G06-32bit;
    fi
    SUDO groupadd wheel
    SUDO usermod -aG wheel $USERNAME

fi
