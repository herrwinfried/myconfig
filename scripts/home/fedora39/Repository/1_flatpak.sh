#!/bin/bash

SUDO $Package $PackageInstall flatpak

SUDO flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
SUDO flatpak remote-add --if-not-exists kdeapps https://distribute.kde.org/kdeapps.flatpakrepo
SUDO flatpak remote-add --if-not-exists gnome-nightly https://nightly.gnome.org/gnome-nightly.flatpakrepo