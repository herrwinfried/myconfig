#!/bin/bash
sudo $PackageName $PackageRemove suse-prime tlp
sudo $PackageName $PackageInstall asusctl asusctl-rog-gui supergfxctl power-profiles-daemon git zsh
sudo systemctl enable --now supergfxd.service
sudo systemctl enable --now asusd.service