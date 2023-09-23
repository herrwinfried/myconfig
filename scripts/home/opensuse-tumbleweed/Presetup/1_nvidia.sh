#!/bin/bash

if ! checkwsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        SUDO $Package $PackageInstall nvidia-compute-G06 nvidia-compute-G06-32bit nvidia-utils-G06 nvidia-video-G06 #xf86-video-intel
    fi
    SUDO groupadd wheel
    SUDO usermod -aG wheel $Username

fi
