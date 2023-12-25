#!/bin/bash

if ! checkwsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        SUDO $Package $PackageInstall akmod-nvidia xorg-x11-drv-nvidia-cuda xorg-x11-drv-nvidia-power xorg-x11-drv-nvidia-cuda-libs nvidia-vaapi-driver libva-utils vdpauinfo

        MOKCheck=$(SUDO mokutil --sb-state | tr '[:upper:]' '[:lower:]' &>/dev/null)

        if [ $MOKCheck == "secureboot enabled" ]; then
            SUDO /usr/sbin/kmodgenca
            SUDO mokutil --import /etc/pki/akmods/certs/public_key.der
            SUDO akmods --rebuild
        fi
    fi
    SUDO groupadd wheel
    SUDO usermod -aG wheel $Username

fi
