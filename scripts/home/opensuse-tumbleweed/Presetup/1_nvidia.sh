#!/bin/bash

if ! CheckWsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        SUDO $Package $PackageInstall nvidia-drivers-G06 nvidia-driver-G06-kmp-default \
        nvidia-video-G06 nvidia-gl-G06 nvidia-compute-G06 \
        nvidia-video-G06-32bit nvidia-gl-G06-32bit nvidia-compute-G06-32bit;
    fi
    SUDO groupadd wheel
    SUDO usermod -aG wheel $USERNAME

fi
