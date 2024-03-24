#!/bin/bash

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

function red_message {
    echo -e $red"$@"$white
}

function CheckLinux {
    if [ "$(uname -s)" != "Linux" ]; then
    red_message $LANG_NOTLINUX
    exit 1;
fi
}


function checkcommand {
    if type -P $1 >/dev/null; then
        return 0
    else
        return 1
    fi
}

function Required_script {
    local i=0

    if [ ! -x $(command -v xdg-user-dirs-update) ]; then
        red_message $LANG_XDG_USER_DIRS_UPDATE_COMMAND_NOT_FOUND
        ((i++))
    fi

    if [ ! -x $(command -v git) ]; then
        red_message $LANG_GIT_COMMAND_NOT_FOUND
        ((i++))
    fi

    if [ ! -x $(command -v dos2unix) ]; then
        red_message $LANG_dos2unix_COMMAND_NOT_FOUND
        ((i++))
    fi

    if [ $i -ne 0 ]; then
        exit 1
    fi
}

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

. /etc/os-release
DISTRO=$(echo $NAME $VERSION | tr '[:upper:]' '[:lower:]')
unset /etc/os-release

BOARD_VENDOR=$(cat /sys/class/dmi/id/board_vendor 2>/dev/null | tr '[:upper:]' '[:lower:]')

USERNAME=$USER
USERHOME=$HOME

EXTERNAL_PACKAGE_DIRS="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)/files"

if [ ! -f "${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs" ]; then

        xdg-user-dirs-update && sleep 1 && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
    else
        source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
    fi


USER_PASSWORD=""
function rootpassword {
if [[ $EUID -eq 0 ]]; then
     echo "$red You must not be Super User/Root. $white"
   exit 1
fi
sudo --reset-timestamp
read -s -p "$cyan""Password for$red root$white : " USER_PASSWORD
echo -e "$yellow\nPassword checking... $white"
if echo "$USER_PASSWORD" | sudo -S true >/dev/null 2>&1; then
    echo -e "$green""Password verified. $white\n"
    function SUDO {
        echo "$USER_PASSWORD" | sudo -S "$@"
    }
else
    echo -e "$red""Password could not be verified $white\n"
    rootpassword
fi  
}

function rootpassword_end {
    unset USER_PASSWORD
    sudo --reset-timestamp
}

function PackageManager_openSUSE-TW {
    SUSE_TYPE=0
    if [[ $1 -eq 1 ]] || [[ $1 -eq 0 ]]; then
        SUSE_TYPE=$1
    else
        SUSE_TYPE=0
    fi
    
    if [[ $SUSE_TYPE -eq 1 ]]; then
        if ! checkcommand dnf ; then
            SUSE_TYPE=0
        fi
    fi

    if [[ $SUSE_TYPE -eq 0 ]]; then
        PackagePrep="zypper"
        Package="$PackagePrep --gpg-auto-import-keys --no-gpg-checks"
        PackageUpdate="dup -y -l"
        PackageRefresh="refresh"

        PackageRemove="rm -u -y"
        PackageInstall="in -y -l"

    elif [[ $SUSE_TYPE -eq 1 ]]; then

        PackagePrep="dnf"
        Package="$PackagePrep --nogpgcheck"
        PackageUpdate="dup -y"
        PackageRefresh="makecache"

        PackageRemove="remove -y"
        PackageInstall="install -y"
    fi
}

function PackageManager_fedora {
    PackagePrep="dnf"
    Package="$PackagePrep --nogpgcheck"
    PackageUpdate="dup -y"
    PackageRefresh="makecache"

    PackageRemove="remove -y"
    PackageInstall="install -y"
}

function PackageManager_debian {
    PackagePrep="apt"
    Package="$PackagePrep"
    PackageUpdate="upgrade -y"
    PackageRefresh="update"

    PackageRemove="remove -y"
    PackageInstall="install -y"
}

function External_PM_Brew {
    BrewPackagePrep="brew"
    BrewPackage="$BrewPackagePrep"
    BrewPackageUpdate="update -y"

    BrewPackageRemove="uninstall -y"
    BrewPackageInstall="install -y"
}

function External_PM_Flatpak {
    FlatpakPackagePrep="flatpak"
    FlatpakPackage="$FlatpakPackagePrep"
    FlatpakPackageUpdate="update -y"

    FlatpakPackageRemove="uninstall -y"
    FlatpakPackageInstall="install -y"
}

function External_PM_Snap {
    SnapPackagePrep="snap"
    SnapPackage="$SnapPackagePrep"
    SnapPackageUpdate="refresh"

    SnapPackageRemove="remove"
    SnapPackageInstall="install"
}

EXE_SHELL() {
  local script_folder="$1"
  for forScriptFile in $(ls -1 "$script_folder" | grep "\.sh$"); do
    echo -e "$magenta $forScriptFile $white\n" && sleep 1
    chmod +x "$script_folder/$forScriptFile"
    dos2unix "$script_folder/$forScriptFile"
    . "$script_folder/$forScriptFile"
  done
}

CHECK_SHELL_DIRECTORY() {
  local folder="$1"
  local distro="$2"
  if [ -d "$ScriptFolder/$folder/$distro" ]; then
    return 0
  else
    return 1
  fi
}

function cdExternalFolder {
    mkdir -p $EXTERNAL_PACKAGE_DIRS
    cd $EXTERNAL_PACKAGE_DIRS
}

function externalPackage {
    cdExternalFolder
    files=$(ls -1 *.flatpakref *.rpm *.deb *.run *.bundle *.appimage 2>/dev/null)

        if [ -n "$files" ]; then
        for file in $files; do
            chmod +x "$file"
            case "$file" in
                *.flatpakref)
               if [ -x $(command -v flatpak) ]; then
                    SUDO $FlatpakPackage $FlatpakPackageInstall "$file"
                    SUDO $FlatpakPackage $FlatpakPackageUpdate
                    SUDO $Package $PackageUpdate
                fi
                    ;;
                *.rpm)
                if [ -x $(command -v zypper) ] || [ -x $(command -v dnf) ] && [ -x $(command -v rpm) ]; then
                    SUDO $Package $PackageInstall "$file"
                    SUDO $Package $PackageUpdate
                fi
                    ;;
                *.deb)
                if [ -x $(command -v apt) ] && [ -x $(command -v dpkg) ]; then
                    SUDO $Package $PackageInstall "$file"
                    SUDO $Package $PackageUpdate
                fi
                    ;;
                *.run)
                    SUDO ./"$file"
                    ;;
                *.bundle)
                    SUDO ./"$file"
                    ;;
                *.appimage)
                    SUDO ./"$file"
                    ;;
            esac
        done
    fi
}

flatpak_user_override() {
    if command -v flatpak &> /dev/null; then
        if [[ -z $2 ]]; then
        flatpak --user override --filesystem=$USERHOME/$1 $2
        else
        flatpak --user override --filesystem=$USERHOME/$1
        fi
    fi
}


create_desktop_entry() {
    local directory_path="$1"
    local icon_name="$2"
    if [[ ! -d $directory_path ]]; then
        mkdir -p "$directory_path"
    fi
    if [[ ! -z $icon_name ]]; then
    echo -e "[Desktop Entry]\nIcon=$icon_name" | tee "$directory_path/.directory"
    fi
}

function HELP_FUNC {

    echo "$LANG_HELP_OPTIONS"
    echo "  -h, --help          $LANG_HELP_HELP"
    echo "  -u, --client        $LANG_HELP_CLIENT"
    echo "  -s, --server        $LANG_HELP_SERVER"
    echo "  -d, --distrobox     $LANG_HELP_DISTROBOX"
    echo "  -ps, --presetup     $LANG_HELP_PRESETUP"
    echo "  -cc, --only-config  $LANG_HELP_ONLY_CONFIG"
    echo "  -c, --config        $LANG_HELP_CONFIG"
    echo ""
    echo "$LANG_HELP_NOTES_TITLE"
    echo "$LANG_HELP_NOTES_DESC"
    echo ""
}
################################################

NEW_HOSTNAME="herrwinfried"
