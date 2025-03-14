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
    export LANG="en_US.UTF-8"
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
        ;;
    "--distrobox" | "-d")
        Distrobox=true
        ;;
    "--presetup" | "-ps")
        Presetup=true
        ;;
    "--only-config" | "-cc")
        OnlyConfig=true
        ;;
    "--config" | "-c")
        Config=true
        ;;
    *) echo -e "${COLORS[Red]}Invalid argument: $arg${COLORS[NoColor]}" ;;
    esac
done

DistroFolder=""
if [[ ${config[distro]} = *opensuse\ tumbleweed ]]; then
    DistroFolder="opensuse-tumbleweed"
    GetPackageManagerVariable dnf5 # zypper
    GetPackageManagerVariable flatpak
    GetPackageManagerVariable brew
elif [[ ${config[distro]} = *opensuse\ tumbleweed-slowroll ]]; then
    DistroFolder="opensuse-tumbleweed-slowroll"
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
    echo -e "${COLORS[Red]}$(Language NOTSUPPORTDISTRO)${COLORS[NoColor]}"
    exit 1
fi

if [ $Client = false ] && [ $Server = false ] && [ $Distrobox = false ]; then
    echo -e "${COLORS[Red]}$(Language NOARGUMENT)${COLORS[NoColor]}"
    exit 1
else

    check_internet
    check_root
    verify_password

    # running scripts inside folders
    if [ $Client = true ]; then
        RunScript "distros" "${DistroFolder}"
    fi

    if [ $Distrobox = true ]; then
        RunScript_Distrobox "${DistroFolder}"
    fi

fi