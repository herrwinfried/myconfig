#!/bin/bash

if ! checkwsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        sudo $Package $PackageUpdate
        sudo $Package $PackageInstall kernel-devel
        sudo $Package $PackageInstall akmod-nvidia xorg-x11-drv-nvidia-cuda

        #MOK
        sudo $Package $PackageInstall kmodtool akmods mokutil openssl
        sudo mokutil --import /etc/pki/akmods/certs/public_key.der
    fi
fi
