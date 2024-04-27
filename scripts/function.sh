#!/bin/bash

Black='\033[0;30m'
DarkBlue='\033[0;34m'
DarkGreen='\033[0;32m'
DarkCyan='\033[0;36m'
DarkRed='\033[0;31m'
DarkMagenta='\033[0;35m'
DarkYellow='\033[0;33m'
Gray='\033[0;37m'
DarkGray='\033[1;30m'
Blue='\033[1;34m'
Green='\033[1;32m'
Cyan='\033[1;36m'
Red='\033[1;31m'
Magenta='\033[1;35m'
Yellow='\033[1;33m'
White='\033[1;37m'
NoColor='\033[0m' # No Color

USER_PASSWORD=""
function rootpassword {
if [[ $EUID -eq 0 ]]; then
     echo -e "${Red}You must not be Super User/Root.${NoColor}"
   exit 1
fi
sudo --reset-timestamp
# shellcheck disable=SC2162
echo -n -e "${Cyan}Password for ${Red}root:${NoColor} "
# shellcheck disable=SC2162
read -s USER_PASSWORD
echo -e "\n${Yellow}Password checking...${NoColor}"
if echo "$USER_PASSWORD" | sudo -S true >/dev/null 2>&1; then
    echo -e "${Green}Password verified.${NoColor}\n"
    function SUDO {
        # shellcheck disable=SC2317
        echo "$USER_PASSWORD" | sudo -S "$@"
    }
else
    echo -e "${Red}Password could not be verified ${NoColor}\n"
    rootpassword
fi  
}
function rootpassword_end {
    unset USER_PASSWORD
    sudo --reset-timestamp
}

function InternetCheck {
 curl -s --head http://www.google.com | grep "200 OK" > /dev/null
    if [ $? -ne 0 ]; then
        echo -e "${Red}You do not have an Internet Connection.${NoColor}"
        exit 1
    fi   
}

function Language {
gettext -s "$1"
}

function echo-red {
    # shellcheck disable=SC2145
    echo -e "${Red}$@ ${NoColor}"
}

function CheckCommand {
    if type -P $1 > /dev/null; then
        return 0
    else
        return 1
    fi
}

function CheckLinux {
    if [ "$(uname -s)" != "Linux" ]; then
    echo-red "$(Language NOTLINUX)"
    exit 1;
    fi
}

function RequireCommand {
    local i=0
    # shellcheck disable=SC2046
    if [[ ! -x $(command -v xdg-user-dirs-update) ]]; then
       echo-red "xdg-user-dirs-update: $(Language NOTFOUND_PACKAGE ||  echo "Not found")"
        ((i++))
    fi

    # shellcheck disable=SC2046
    if [[ ! -x $(command -v git) ]]; then
       echo-red "Git: $(Language NOTFOUND_PACKAGE ||  echo "Not found")"
        ((i++))
    fi

    # shellcheck disable=SC2046
    if [[ ! -x $(command -v dos2unix) ]]; then
       echo-red "dos2unix: $(Language NOTFOUND_PACKAGE ||  echo "Not found")"
        ((i++))
    fi
    # shellcheck disable=SC2046
    if [[ ! -x $(command -v gettext) ]]; then
       echo-red "gettext: $(Language NOTFOUND_PACKAGE ||  echo "Not found")"
        ((i++))
    fi

    if [ $i -ne 0 ]; then
        exit 1
    fi
}

function CheckWsl {
    unameout=$(uname -r | tr '[:upper:]' '[:lower:]')
    if [[ "$unameout" = "*microsoft*" || "$unameout" = "*wsl*" ]] ||
        [ -f /proc/sys/fs/binfmt_misc/WSLInterop ] ||
        [ "$WSL_DISTRO_NAME" ] ||
        [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" = "0xffffffff" ] && [ "$WSL_DISTRO_NAME" ]; then
        return 0
    else
        return 1
    fi
}

if [ ! -f "${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs" ]; then
    xdg-user-dirs-update && sleep 1 && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
else
    source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
fi

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


function ExternalPackage {
    mkdir -p $EXTERNAL_PACKAGE_DIRS
    cd $EXTERNAL_PACKAGE_DIRS
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

function CreateDesktopEntry() {
    local directory_path="$1"
    local icon_name="$2"
    if [[ ! -d $directory_path ]]; then
        mkdir -p "$directory_path"
    fi
    if [[ -n $icon_name ]]; then
    echo -e "[Desktop Entry]\nIcon=$icon_name" | tee "$directory_path/.directory"
    fi
}


function flatpak_user_override() {
    if command -v flatpak &> /dev/null; then
        if [[ -z $2 ]]; then
        flatpak --user override --filesystem=$1 $2
        else
        flatpak --user override --filesystem=$1
        fi
    fi
}

function CheckScriptDirectory {
    local Type="$1"
    local Distro="$2"

        # shellcheck disable=SC2154
        if [ -d "${GetScriptDir}/${Type}/${Distro}" ]; then
            return 0
        else 
            return 1
        fi
}

function RunScriptFile {
    local Folder="$1"
    for scriptfile in $(ls -1 "$Folder" | grep "\.sh$"); do
        echo -e "${Magenta}${Folder}/${scriptfile}${NoColor}"
        dos2unix "${Folder}/${scriptfile}"
        chmod +x "${Folder}/${scriptfile}"
        # shellcheck disable=SC1090
        . "${Folder}/${scriptfile}"
    done
}

function RunScript {
    local Type="$1"
    local Dir="$2"
    local result=$(CheckScriptDirectory $Type $Dir)
    # shellcheck disable=SC1009
    if ! $result; then
    echo-red "$(Language NOTSUPPORTDISTRO) [${Type}]"
    exit 1
    fi
        if [ "$Presetup" = true ]; then
            RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Repository"
            RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Presetup"
            PreSetupFinishMessage
            exit 1
        fi
        if [ "$OnlyConfig" = true ]; then
            RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Config"
            exit 1
        fi
        RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Repository"
        RunScriptFile "${GetScriptDir}/${Type}/${Dir}/FirstProcess"
        RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Package"
        if [ "$Config" = true ]; then
            RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Config"
        fi
        RunScriptFile "${GetScriptDir}/${Type}/${Dir}/RecentProcess"

}

function RunScript_Distrobox {
    local Type="distrobox"
    local Dir="$1"
    local dx_distro=$DX_OS
    # shellcheck disable=SC1009
    if ! CheckScriptDirectory "$Type" "$Dir"; then
    echo-red "$(Language NOTSUPPORTDISTRO) [${Type}]"
    exit 1
    else
        if [ "$Presetup" ]; then
            RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Repository"
            RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/Presetup"
            PreSetupFinishMessage
            exit 1
        fi
        if [ "$OnlyConfig" ]; then
            RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/Config"
            exit 1
        fi
        RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/Repository"
        RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/FirstProcess"
        RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/Package"
        if [ "$Config" ]; then
            RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/Config"
        fi
        RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/RecentProcess"
    fi
}

function PreSetupFinishMessage {
    echo -e "${Yellow}$(Language PreSetupMessageOne)${NoColor}"
    echo -e "${Cyan}$(Language PreSetupMessageTwo)${NoColor}"
    exit 1;
}

basic_if_warning() {
  echo -e "${Yellow}$(Language BOTH_WARNING)${NoColor}"
  echo "[1] $(Language BOTH_WARNING_YES)"
  echo "[2] $(Language BOTH_WARNING_NO)"
  read -r IFREAD
  if [ "$IFREAD" -ne 1 ] && [ "$IFREAD" -ne 2 ]; then
    echo -e "${Red}$(Language BOTH_WARNING_INVALID) ${NoColor}"
    basic_if_warning
  elif [ "$IFREAD" -eq 2 ]; then
    exit 1
  fi
}

function BasePackageInstall {
if [[ -n $1 ]]; then
    SUDO $Package $PackageInstall $1
fi
}

function BasePackageFlatpakInstall {
if [[ -n $1 ]]; then
    SUDO $FlatpakPackage $FlatpakPackageInstall $1
fi
}
