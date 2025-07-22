#!/bin/bash
GetScriptDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
GetDataDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../data && pwd)
GetScriptName=$(basename "${BASH_SOURCE[0]}")

if [[ "$(uname -s)" != "Linux" ]]; then
    echo -e "${COLORS[Red]}This script is designed for Linux.${COLORS[NoColor]}"
    exit 1
fi

export TEXTDOMAINDIR="${GetScriptDir}/locale"
export TEXTDOMAIN="${GetScriptName}"

if [ ! -f "${TEXTDOMAINDIR}/en_US/LC_MESSAGES/${GetScriptName}.mo" ]; then
    echo "There is no language file. Script exited."
    exit 1
elif [[ ! -f "${TEXTDOMAINDIR}/$(echo "$LANG" | cut -d '.' -f 1)/LC_MESSAGES/${GetScriptName}.mo" ]]; then
    export LC_ALL="en_US.UTF-8"
fi

if [ -f function.sh ]; then
    # shellcheck disable=SC1091
    . ./function.sh
else
    echo "there is no function file. Script exited"
    exit 1
fi

if [ -f config.sh ]; then
    # shellcheck disable=SC1091
    . ./config.sh
else
    echo "there is no config file. Script exited"
    exit 1
fi

for arg in "$@"; do
    case "${arg,,}" in
    -h | --help)
        HelpFunction
        exit 0
        ;;
    "--client" | "--user" | "-u")
        Client=true
        Distrobox=false
        ;;
    "--distrobox" | "-d")
        Distrobox=true
        Client=false
        ;;
    "--presetup" | "-ps")
        Presetup=true
        ;;
    "--only-config" | "-cc")
        OnlyConfig=true
        Config=false
        ;;
    "--config" | "-c")
        Config=true
        ;;
    *) red_message "$(GetLanguage INVALID_ARGS): $arg" ;;
    esac
done

DistroFolder=""
if [[ ${config[distro]} = *opensuse\ tumbleweed ]]; then
    DistroFolder="opensuse-tumbleweed"
    GetPackageManagerVariable dnf5 # zypper
    GetPackageManagerVariable flatpak
    GetPackageManagerVariable brew
elif [[ ${config[distro]} = *opensuse\ tumbleweed-slowroll ]]; then
    DistroFolder="opensuse-slowroll"
    GetPackageManagerVariable dnf5 # zypper
    GetPackageManagerVariable flatpak
    GetPackageManagerVariable brew
elif [[ ${config[distro]} = *fedora* ]]; then
    DistroFolder="fedora"
    GetPackageManagerVariable dnf
    GetPackageManagerVariable flatpak
    GetPackageManagerVariable brew
elif [[ ${config[distro]} = *debian* ]]; then
    DistroFolder="debian"
    GetPackageManagerVariable apt
    GetPackageManagerVariable flatpak
    GetPackageManagerVariable brew
else
    red_message "$(GetLanguage NOT_SUPPORT_DISTRO)"
    exit 1
fi

if [ $Client = false ] && [ $Distrobox = false ]; then
    red_message "$(GetLanguage NO_ARGS)"
    exit 1
else

    check_internet
    check_root
    verify_password

    CreateDirectory ${config["external_package_dirs"]}

    if [ $Client = true ]; then
        RunScript "distros" "${DistroFolder}"
    fi

    if [ $Distrobox = true ]; then
        RunScript "distrobox" "${DistroFolder}"
    fi

fi
