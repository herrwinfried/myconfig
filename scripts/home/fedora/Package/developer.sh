#!/bin/bash

if ! CheckWsl; then
    DevContainer="$(echo docker-{ce,ce-cli,buildx-plugin,compose-plugin,compose}) containerd.io podman podman-compose distrobox"
    DevContainer_Flatpak="flathub io.podman_desktop.PodmanDesktop"
    /usr/bin/dockerd-rootless-setuptool.sh install
fi

DevLang="@c-development gdb clang gcc gcc-c++ $(echo cmake{,-rpm-macros}) extra-cmake-modules"
DevLang+=" dotnet-sdk-8.0 mono-devel @development-tools @rpm-development-tools python3.13"
DevLang+=" nodejs nodejs-npm build ninja git git-lfs"
if ! CheckWsl; then
    DevLang+=" qt6-qtbase-devel qt6-qtdeclarative-devel"
fi


if ! CheckWsl; then
    DevEditor="code filezilla $(echo qt{6-qttools,-creator,-creator-translations}) okteta"
    DevEditor+=" $(echo qt6-{assistant,designer,linguist})"
    DevEditor_Flatpak="flathub org.kde.Ikona"
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