#!/bin/bash

#It makes more sense to use direct os-release instead of lsb-release
. /etc/os-release

OS_Name=$NAME
OS_Version=$VERSION
distro=$(echo $OS_Name $OS_Version | tr '[:upper:]' '[:lower:]')
BOARD_VENDOR=$(cat /sys/class/dmi/id/board_vendor 2>/dev/null | tr '[:upper:]' '[:lower:]')
NEW_HOSTNAME="herrwinfried"

source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs

Username=$USER
HomePWD=$HOME
ExternalFolder="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)/files"

# Colors
termcols=$(tput cols)
bold="$(tput bold)"
fontnormal="$(tput init)"
fontreset="$(tput reset)"
underline="$(tput smul)"
standout="$(tput smso)"
normal="$(tput sgr0)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
# Colors Finish

function checkwsl() {
    unameout=$(uname -r | tr '[:upper:]' '[:lower:]')
    if [[ "$unameout" = "*microsoft*" || "$unameout" = "*wsl*" ]] ||
        [ -f /proc/sys/fs/binfmt_misc/WSLInterop ] ||
        [ $WSL_DISTRO_NAME ] ||
        [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" = "0xffffffff" ] && [ $WSL_DISTRO_NAME ]; then
        return 0
    else
        return 1
    fi
}

function sudoreq {
    sudo -v || {
        echo -e $red"Cancel..."$white
        exit 1
    }
}

function sudofinish {
    sudo --reset-timestamp
}

function cdExternalFolder {
    mkdir -p $ExternalFolder
    cd $ExternalFolder
}

function checkcommand {
    if type -P $1 >/dev/null; then
        return 0
    else
        return 1
    fi
}

function openSUSETW_ALIAS {
    # ZYPPER OR DNF
    #   0        1
    SUSE_TYPE=0
    if ! checkcommand dnf; then
        SUSE_TYPE=0
    fi
    ################

    if [ $SUSE_TYPE -eq 1 ]; then
        if ! checkcommand dnf ; then
            SUSE_TYPE=0
        fi
    fi

    if [ $SUSE_TYPE -eq 0 ]; then
        PackagePrep="zypper"
        Package="$PackagePrep --gpg-auto-import-keys --no-gpg-checks"
        PackageUpdate="dup -y -l"
        PackageRefresh="refresh"

        PackageRemove="rm -u -y"
        PackageInstall="in -y -l"

    elif [ $SUSE_TYPE -eq 1 ]; then

        PackagePrep="dnf"
        Package="$PackagePrep --nogpgcheck"
        PackageUpdate="dup -y"
        PackageRefresh="makecache"

        PackageRemove="remove -y"
        PackageInstall="install -y"
    fi


if [ ! -x $(command -v xdg-user-dirs-update) ]; then
sudo zypper in -y -l xdg-user-dirs
xdg-user-dirs-update
source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
fi
}

function fedora_ALIAS {
    PackagePrep="dnf"
    Package="$PackagePrep --nogpgcheck"
    PackageUpdate="update -y"
    PackageRefresh="makecache"

    PackageRemove="remove -y"
    PackageInstall="install -y"
}

BrewPackagePrep="brew"
BrewPackage="$BrewPackagePrep"
BrewPackageUpdate="update -y"

BrewPackageRemove="uninstall -y"
BrewPackageInstall="install -y"

FlatpakPackagePrep="flatpak"
FlatpakPackage="$FlatpakPackagePrep"
FlatpakPackageUpdate="update -y"

FlatpakPackageRemove="uninstall -y"
FlatpakPackageInstall="install -y"

SnapPackagePrep="snap"
SnapPackage="$SnapPackagePrep"
SnapPackageUpdate="refresh"

SnapPackageRemove="remove"
SnapPackageInstall="install"
