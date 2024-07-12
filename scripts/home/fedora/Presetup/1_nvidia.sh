#!/bin/bash

if ! CheckWsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        SUDO $Package $PackageInstall kmodtool akmods mokutil openssl \
        akmod-nvidia xorg-x11-drv-nvidia-cuda vulkan \
        xorg-x11-drv-nvidia-cuda-libs nvidia-vaapi-driver libva-utils;
        SUDO kmodgenca -a
        SUDO mokutil --import /etc/pki/akmods/certs/public_key.der
    
    fi
    SUDO groupadd wheel
    SUDO usermod -aG wheel $USERNAME

fi
