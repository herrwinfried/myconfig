#!/bin/bash

if ! isWsl; then
    if [[ "${config[board_vendor]}" == *"asus"* ]]; then
        SUDO zypper --gpg-auto-import-keys --no-gpg-checks rm -y suse-prime tlp
        SUDO zypper --gpg-auto-import-keys --no-gpg-checks al suse-prime
        SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l power-profiles-daemon asusctl supergfxctl asusctl-rog-gui
        SUDO systemctl enable --now supergfxd.service
        SUDO systemctl enable --now asusd.service
    fi
fi