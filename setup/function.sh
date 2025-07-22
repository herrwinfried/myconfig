#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
SCRIPT_NAME="$(basename "${BASH_SOURCE[0]}")"

function red_message {
    # shellcheck disable=SC2145
    echo -e "${COLORS[Red]}$@${COLORS[NoColor]}"
}
function yellow_message {
    # shellcheck disable=SC2145
    echo -e "${COLORS[Yellow]}$@${COLORS[NoColor]}"
}
function green_message {
    # shellcheck disable=SC2145
    echo -e "${COLORS[Green]}$@${COLORS[NoColor]}"
}

function GetLanguage {
    gettext "$1"
}

function is_command() {
    if command -v "$1" &>/dev/null; then
        return 0
    else
        red_message "$(GetLanguage NOT_FOUND): $1"
        return 1
    fi
}

function check_root() {
    if [[ $EUID -eq 0 ]]; then
        red_message "$(GetLanguage NOT_ROOT)"
        exit 1
    fi
}

function verify_password() {
    echo -n -e "${COLORS[Cyan]}$(GetLanguage "INPUT_PASSWORD"):${COLORS[NoColor]} "
    read -s user_password
    yellow_message "$(GetLanguage VERIFY_PASSWORD)"
    echo "$user_password" | sudo -S true &>/dev/null && return 0 || {
        red_message "$(GetLanguage ERROR_PASSWORD)"
        verify_password
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
    curl -s --head https://duckduckgo.com | grep "200" &>/dev/null || {
        red_message "$(GetLanguage NO_INTERNET)"
        exit 1
    }
}

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
        BPM_Refresh="update"
        BPM_Upgrade="upgrade"
        BPM_Install="install"
        BPM_Uninstall="uninstall"
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

function CreateDirectory() {
    local directory_path="$1"
    local icon_name="$2"
    if [[ ! -d $directory_path ]]; then
        mkdir -p "$directory_path"
    fi
    if [[ -n $icon_name ]]; then
        echo -e "[Desktop Entry]\nIcon=$icon_name" | tee "$directory_path/.directory"
    fi
}

function flatpakOverrideFs() {
    if command -v flatpak &>/dev/null; then
        local user=$1
        local fsystem=$2
        local appname=$3
        local flatargs
        if [[ $user == true ]]; then
            flatargs="--user"
        fi
        if [[ -z $appname ]]; then
            flatpak $flatargs override --filesystem=$fsystem $appname
        else
            flatpak $flatargs override --filesystem=$fsystem
        fi
    fi
}

function ExternalPackage() {
    green_message "===== ${config["external_package_dirs"]} ====="
    CreateDirectory ${config["external_package_dirs"]}
    cd ${config["external_package_dirs"]}
    local files=$(ls -1 *.flatpakref *.rpm *.deb *.run *.bundle *.appimage 2>/dev/null)

    if [ -n "$files" ]; then
        for file in $files; do
            chmod +x "$file"
            case "$file" in
            *.flatpakref)
                if is_command flatpak; then
                    SUDO $FPM $FPM_Install "$file"
                fi
                ;;
            *.rpm)
                if is_command zypper || is_command dnf; then
                    SUDO $PM $PM_Install "$file"
                fi
                ;;
            *.deb)
                if is_command apt; then
                    SUDO $PM $PM_Install "$file"
                fi
                ;;
            *.rootless.run)
                ./$file
                ;;
            *.run)
                SUDO ./$file
                ;;
            *.rootless.bundle)
                ./$file
                ;;
            *.bundle)
                SUDO ./$file
                ;;
            *.rootless.appimage)
                ./$file
                ;;
            *.appimage)
                SUDO ./$file
                ;;
            esac
        done
    fi

}

function CheckScriptDirectory {
    local DistroDirectory="$1"
    local Distro="$2"
    # shellcheck disable=SC2154
    if [ -d "${GetScriptDir}/${DistroDirectory}/${Distro}" ]; then
        return 0
    else
        return 1
    fi
}

function RunScriptFile {
    local Folder="$1"
    # shellcheck disable=SC2010
    for scriptfile in $(ls -1 "$Folder" | grep "\.sh$"); do
        yellow_message "${Folder}/${scriptfile}"
        dos2unix "${Folder}/${scriptfile}"
        chmod +x "${Folder}/${scriptfile}"
        # shellcheck disable=SC1090
        . "${Folder}/${scriptfile}"
    done
}

function RunScript {
    local DistroDirectory="$1"
    local Distro="$2"
    local fpath
    if [[ $DistroDirectory == "distrobox" ]]; then
        fpath="${DX_OS}/${Distro}"
    else
        fpath="${Distro}"
    fi

    # shellcheck disable=SC2155
    local result=$(CheckScriptDirectory "$DistroDirectory" "$Distro")
    # shellcheck disable=SC1009
    if ! $result; then
        echo-red "$(Language NOT_SUPPORT_DISTRO) [${DistroDirectory}]"
        exit 1
    fi
    # shellcheck disable=SC2154
    if [ "$Presetup" = true ]; then
        RunScriptFile "${GetScriptDir}/${DistroDirectory}/${fpath}/Repository"
        RunScriptFile "${GetScriptDir}/${DistroDirectory}/${fpath}/Presetup"
        PreSetupFinishMessage
        exit 1
    fi
    # shellcheck disable=SC2154
    if [ "$OnlyConfig" = true ]; then
        RunScriptFile "${GetScriptDir}/${DistroDirectory}/${fpath}/Config"
        exit 1
    fi
    RunScriptFile "${GetScriptDir}/${DistroDirectory}/${fpath}/Repository"
    RunScriptFile "${GetScriptDir}/${DistroDirectory}/${fpath}/Process"
    # shellcheck disable=SC2154
    if [ "$Config" = true ]; then
        RunScriptFile "${GetScriptDir}/${DistroDirectory}/${fpath}/Config"
    fi
}
function PreSetupFinishMessage {
    echo -e "${COLORS[Yellow]}$(Language PreSetupMessageOne)${COLORS[NoColor]}"
    echo -e "${COLORS[Cyan]}$(Language PreSetupMessageTwo)${COLORS[NoColor]}"
    exit 1
}
