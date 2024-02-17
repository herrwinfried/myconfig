#!/bin/bash

PackageA="iproute igt-gpu-tools"

WSL_Package0="adwaita-icon-theme gnome-icon-theme google-noto-sans-fonts powerline-fonts xeyes systemd"
WSL_Package1="gsettings-desktop-schemas libwayland-client libwayland-cursor libwayland-server materia-gtk-theme gnome-tweaks qt5ct"
WSL_Package1+=" mesa-libOSMesa-devel glib2 tslib xcb-util-wm xcb-util-image xcb-util-keysyms xcb-util-renderutil libevent libminizip1 pcre2-utf16"

SUDO $Package $PackageInstall gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel
SUDO dnf install lame\* --exclude=lame-devel
SUDO dnf group upgrade --with-optional Multimedia
SUDO $Package $PackageInstall $PackageA
if checkwsl; then
 SUDO $Package $PackageInstall $WSL_Package0
 SUDO $Package $PackageInstall $WSL_Package1
else
SUDO systemctl enable nvidia-{hibernate,suspend,resume}.service
 fi

