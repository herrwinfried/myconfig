#!/bin/bash

if ! checkwsl; then
    if [[ $BOARD_VENDOR == *"asus"* ]]; then
        sudo $Package $PackageInstall asusctl asusctl-rog-gui supergfxctl
        sudo systemctl enable --now supergfxd.service
        sudo systemctl enable --now asusd.service
    fi
fi
