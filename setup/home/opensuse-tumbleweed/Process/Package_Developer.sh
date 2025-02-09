#!/bin/bash

DevContainer="docker docker-compose"
if ! CheckWsl; then
    DevContainer+=" podman distrobox"
    DevContainer_Flatpak="flathub io.podman_desktop.PodmanDesktop"
    /usr/bin/dockerd-rootless-setuptool.sh install
fi

DevLang="patterns-devel-C-C++-devel_C_C++ gdb clang gcc gcc-c++ cmake cmake-full extra-cmake-modules"
DevLang+=" $(echo {dotnet-sdk,aspnetcore-runtime,dotnet-runtime}-8.0) $(echo {krb5,zlib}-devel) patterns-devel-mono-devel_mono patterns-devel-base-devel_rpm_build python312"
DevLang+="  python312-pip nodejs npm-default build ninja git git-lfs"

if ! CheckWsl; then
    DevEditor="code filezilla okteta ikona"
fi

BasePackageInstall "$DevContainer"
BasePackageFlatpakInstall "$DevContainer_Flatpak"

BasePackageInstall "$DevLang"
BasePackageFlatpakInstall "$DevLang_Flatpak"

if [[ -x $(command -v dotnet) ]]; then
SUDO dotnet workload install wasm-tools
dotnet new install Avalonia.Templates
fi

BasePackageInstall "$DevEditor"
BasePackageFlatpakInstall "$DevEditor_Flatpak"

if ! CheckWsl; then
    SUDO usermod -aG docker $USERNAME
fi