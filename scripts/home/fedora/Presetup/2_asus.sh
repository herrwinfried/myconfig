#!/bin/bash

if ! CheckWsl; then
    if [[ $BOARD_VENDOR == *"asus"* ]]; then
        SUDO $Package $PackageInstall power-profiles-daemon asusctl supergfxctl asusctl-rog-gui
        SUDO systemctl enable --now supergfxd.service
        SUDO systemctl enable --now asusd.service
    fi
fi
