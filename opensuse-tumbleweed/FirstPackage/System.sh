#!/bin/bash

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then

sudo zypper --gpg-auto-import-keys install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full

sudo zypper install --recommends -y patterns-wsl-base patterns-wsl-gui patterns-wsl-systemd

sudo $PackageName $PackageInstall noto-sans-fonts gsettings-desktop-schemas xorg-x11-libs xorg-x11-server humanity-icon-theme materia-gtk-theme gnome-tweaks qt5ct \
Mesa-devel libOSMesa-devel libgthread-2_0-0 libts0 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-render-util0 libevent-2_1-7 libminizip1 libpcre2-16-0 \
Mesa-libva net-tools

elif [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
sudo zypper --gpg-auto-import-keys install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs
sudo $PackageName remove -y tlp
sudo $PackageName $PackageInstall systemd-zram-service power-profiles-daemon net-tools
sudo systemctl enable zramswap.service


sudo hostnamectl set-hostname $HOSTNAME_NEW

sudo mkdir -p /etc/systemd/system/bluetooth.service.d
sudo touch /etc/systemd/system/bluetooth.service.d/override.conf
echo "[Service]
ExecStart=
ExecStart=/usr/libexec/bluetooth/bluetoothd -E" >> /etc/systemd/system/bluetooth.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart bluetooth

sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service
fi