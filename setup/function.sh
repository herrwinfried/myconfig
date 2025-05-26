#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

function is_command() { command -v "$1" &>/dev/null; }

function check_root() {
    if [[ $EUID -eq 0 ]]; then
        echo -e "${COLORS[Red]}You must not run this script as root.${COLORS[NoColor]}"
        exit 1
    fi
}

function verify_password() {
    echo -n -e "${COLORS[Cyan]}Password for ${COLORS[Red]}root:${COLORS[NoColor]} "
    read -s user_password
    echo -e "\n${COLORS[Yellow]}Verifying password...${COLORS[NoColor]}"
    echo "$user_password" | sudo -S true &>/dev/null && return 0 || {
        echo -e "${COLORS[Red]}Incorrect password.${COLORS[NoColor]}"
        exit 1
    }
}

function SUDO() {
    echo "$user_password" | sudo -S "$@"
}

function cleanup() {
    unset user_password
    sudo --reset-timestamp
}
trap cleanup EXIT

function check_internet() {
    curl -s --head http://www.google.com | grep "200" &>/dev/null || {
        echo -e "${COLORS[Red]}No Internet connection.${COLORS[NoColor]}"
        exit 1
    }
}

function Language {
    gettext -s "$1"
}

function echo-red {
    # shellcheck disable=SC2145
    echo -e "${Red}$@ ${NoColor}"
}

. /etc/os-release

if [ ! -f "${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs" ]; then
    xdg-user-dirs-update && sleep 1 && source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
else
    source ${XDG_CONFIG_HOME:-~/.config}/user-dirs.dirs
fi

function get_package_manager() {
    case "$DISTRO" in
    *"opensuse tumbleweed"*) echo "zypper" ;;
    *"fedora"*) echo "dnf" ;;
    *"debian"* | *"ubuntu"*) echo "apt" ;;
    *) echo "unsupported" ;;
    esac
}

get_zypper_command() {
    local distro=$(echo "$NAME $VERSION" | tr '[:upper:]' '[:lower:]')
    local dup_distros=("tumbleweed" "slowroll" "microos" "kubic")
    local up_distros=("leap")
    for dup_distro in "${dup_distros[@]}"; do
        if [[ $distro == *"$dup_distro"* ]]; then
            echo "dup"
            return
        fi
    done
    for up_distro in "${up_distros[@]}"; do
        if [[ $distro == *"$up_distro"* ]]; then
            echo "up"
            return
        fi
    done
    echo "up"
}

get_dnf_command() {
    local distro=$(echo "$NAME $VERSION" | tr '[:upper:]' '[:lower:]')
    local dup_distros=("tumbleweed" "slowroll" "microos" "kubic")
    local up_distros=("leap")
    for dup_distro in "${dup_distros[@]}"; do
        if [[ $distro == *"$dup_distro"* ]]; then
            echo "distro-sync"
            return
        fi
    done
    for up_distro in "${up_distros[@]}"; do
        if [[ $distro == *"$up_distro"* ]]; then
            echo "upgrade"
            return
        fi
    done
    echo "upgrade"
}

function GetPackageManagerVariable() {
    local pm=$1
    local isYes="-y"
    case $pm in
    zypper)
        PM="zypper"
        PM_Refresh="refresh ${isYes}"
        PM_Upgrade="$(get_zypper_command) ${isYes}"
        PM_Install="install ${isYes}"
        PM_Uninstall="rm ${isYes}"
        ;;
    dnf)
        PM="dnf"
        PM_Refresh="makecache ${isYes}"
        PM_Upgrade="$(get_dnf_command) ${isYes}"
        PM_Install="install --skip-broken ${isYes}"
        PM_Uninstall="remove ${isYes}"
        ;;
    dnf5)
        PM="dnf5"
        PM_Refresh="makecache ${isYes}"
        PM_Upgrade="$(get_dnf_command) ${isYes}"
        PM_Install="install --skip-broken ${isYes}"
        PM_Uninstall="remove ${isYes}"
        ;;
    apt)
        PM="apt"
        PM_Refresh="update ${isYes}"
        PM_Upgrade="upgrade ${isYes}"
        PM_Install="install ${isYes}"
        PM_Uninstall="remove ${isYes}"
        ;;
    flatpak)
        FPM="flatpak"
        FPM_Refresh="update ${isYes}"
        FPM_Upgrade="update ${isYes}"
        FPM_Install="install ${isYes}"
        FPM_Uninstall="uninstall ${isYes}"
        ;;
    brew)
        BPM="/home/linuxbrew/.linuxbrew/bin/brew"
        BPM_Refresh="update ${isYes}"
        BPM_Upgrade="upgrade ${isYes}"
        BPM_Install="install ${isYes}"
        BPM_Uninstall="uninstall ${isYes}"
        ;;
    snap)
        SPM="snap"
        SPM_Refresh="refresh ${isYes}"
        SPM_Upgrade="refresh ${isYes}"
        SPM_Install="install ${isYes}"
        SPM_Uninstall="uninstall ${isYes}"
        ;;
    *)
        echo -e "${COLORS[Red]}Invalid package manager: $manager${COLORS[NoColor]}"
        return
        ;;
    esac
}

function PackageInstall {
    SUDO su -c "$PM $PM_Install $@"
}
function PackageUnInstall {
    SUDO su -c "$PM $PM_Uninstall $@"
}

function FlatpakPackageInstall {
    SUDO su -c "$FPM $FPM_Install $@"
}

function isWsl {
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
    if command -v flatpak &>/dev/null; then
        if [[ -z $2 ]]; then
            flatpak --user override --filesystem=$1 $2
        else
            flatpak --user override --filesystem=$1
        fi
    fi
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
                    SUDO $FPM $FPM_Install "$file"
                    SUDO $FPM $FPM_Refresh
                fi
                ;;
            *.rpm)
                if [ -x $(command -v zypper) ] || [ -x $(command -v dnf) ] && [ -x $(command -v rpm) ]; then
                    SUDO $PM $PM_Install "$file"
                    SUDO $PM $PM_Refresh
                fi
                ;;
            *.deb)
                if [ -x $(command -v apt) ] && [ -x $(command -v dpkg) ]; then
                    SUDO $PM $PM_Install "$file"
                    SUDO $PM $PM_Refresh
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
    RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Process"
    if [ "$Config" = true ]; then
        RunScriptFile "${GetScriptDir}/${Type}/${Dir}/Config"
    fi

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
        RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/Process"
        if [ "$Config" ]; then
            RunScriptFile "${GetScriptDir}/${Type}/${dx_distro}/${Dir}/Config"
        fi
    fi
}

function PreSetupFinishMessage {
    echo -e "${Yellow}$(Language PreSetupMessageOne)${NoColor}"
    echo -e "${Cyan}$(Language PreSetupMessageTwo)${NoColor}"
    exit 1
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