#!/bin/bash

SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l "flatpak"

SUDO flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo