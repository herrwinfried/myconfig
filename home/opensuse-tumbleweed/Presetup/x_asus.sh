#!/bin/bash

if ! checkwsl; then
    if [[ $BOARD_VENDOR == *"asus"* ]]; then
        sudo $Package $PackageRemove suse-prime tlp
        sudo $Package al suse-prime
        sudo $Package $PackageInstall power-profiles-daemon asusctl supergfxctl asusctl-rog-gui
        sudo systemctl enable --now supergfxd.service
        sudo systemctl enable --now asusd.service
    fi
fi
