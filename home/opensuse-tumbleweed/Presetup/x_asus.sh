#!/bin/bash

if ! checkwsl; then
    sudo $Package $PackageRemove suse-prime tlp
    sudo $Package al suse-prime
    sudo $Package $PackageInstall power-profiles-daemon asusctl asusctl-rog-gui supergfxctl power-profiles-daemon git zsh
    sudo systemctl enable --now supergfxd.service
    sudo systemctl enable --now asusd.service

fi
