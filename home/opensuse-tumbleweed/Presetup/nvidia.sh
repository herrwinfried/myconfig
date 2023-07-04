#!/bin/bash

if ! checkwsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        sudo $Package $PackageInstall nvidia-glG06 x11-video-nvidiaG06 nvidia-drivers-G06 #xf86-video-intel
    fi
    sudo groupadd wheel
    sudo usermod -aG wheel $Username

fi
