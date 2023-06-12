#!/bin/bash
sudo $Package swap -y ffmpeg-free ffmpeg --allowerasing
sudo $Package groupupdate -y multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo $Package groupupdate -y sound-and-video

if checkwsl; then

    sudo $Package $PackageInstall lato-fonts adwaite-icon-theme gnome-icon-theme noto-sans-fonts powerline-fonts xeyes
    sudo $Package $PackageInstall systemd xorg-x11-server humanity-icon-theme materia-gtk-theme gnome-tweaks qt5ct \
        mesa-libOSMesa-devel glib2 tslib libxcb libevent
else
    sudo $Package $PackageInstall igt-gpu-tools

    sudo systemctl enable nvidia-{hibernate,suspend,resume}.service
fi
