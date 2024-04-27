#!/bin/bash

if ! CheckWsl; then
    DevContainer="docker docker-compose podman distrobox"
    DevContainer_Flatpak="flathub io.podman_desktop.PodmanDesktop"
    /usr/bin/dockerd-rootless-setuptool.sh install
fi

DevLang="patterns-devel-C-C++-devel_C_C++ gdb clang gcc gcc-c++ cmake cmake-full extra-cmake-modules"
DevLang+=" dotnet-sdk-8.0 patterns-devel-mono-devel_mono patterns-devel-base-devel_rpm_build python312"
DevLang+="  python312-pip nodejs npm-default build ninja git git-lfs"
if ! CheckWsl; then
    DevLang+=" qt6-base-devel qt6-declarative-devel"
fi


if ! CheckWsl; then
    DevEditor="code filezilla qt6-tools qt6-creator okteta ikona"
    DevEditor+=" qt6-tools-assistant qt6-tools-designer qt6-tools-linguist qt6-tools-qdbus qt6-translations"
fi

BasePackageInstall "$DevContainer"
BasePackageFlatpakInstall "$DevContainer_Flatpak"

BasePackageInstall "$DevLang"
BasePackageFlatpakInstall "$DevLang_Flatpak"

dotnet new install Avalonia.Templates

BasePackageInstall "$DevEditor"
BasePackageFlatpakInstall "$DevEditor_Flatpak"

if ! CheckWsl; then
    SUDO usermod -aG docker $USERNAME
fi