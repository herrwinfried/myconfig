#!/bin/bash

zypper addrepo https://download.opensuse.org/repositories/home:hopeandtruth6517:kirigami-apps/openSUSE_Tumbleweed/home:hopeandtruth6517:kirigami-apps.repo
sudo zypper --gpg-auto-import-keys refresh

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
### partitionmanager, kclock, digikam,colord-kde, Ses kayıt edici, Video oynatıcı, Metin düzenleyici , Dosya yöneticisi , KDIFF, Takvim, kdeconnect, dosya bulucu, GPG , kamera, kde IDE, KDE IDE PHP VE QT , Google Drive KDE  , Discover flatpak support, paint uygulaması, music uygulaması, dolphin plugin, megaSYNC dolphin
packageKde="partitionmanager kclock digikam colord-kde krecorder dragonplayer kwrite krename kdiff3 kalendar kdeconnect-kde kate kfind kleopatra kamoso kdevelop5 kdevelop5-plugin-php kdevelop5-pg-qt kio-gdrive discover-backend-flatpak kolourpaint elisa dolphin-plugins dolphin-megasync"
sudo $PackageName $PackageInstall $packageKde 
fi
