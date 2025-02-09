#!/bin/bash

SUDO $Package $PackageInstall flatpak

SUDO flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo