#!/bin/bash
GetScriptDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
GetDataDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd ../data && pwd)
GetScriptName=$(basename "${BASH_SOURCE[0]}")

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

RequireCommand

if [ -f config.sh ]; then
# shellcheck disable=SC1091
. ./config.sh
else
echo "there is no config file. Script exited"
exit 1
fi

# Options
Client=false
Server=false
Distrobox=false

Presetup=false

OnlyConfig=false
Config=false

#########
i=1
j=$#
while [ $i -le $j ]; do
  n=$(echo $1 | tr '[:upper:]' '[:lower:]')
  case $n in
    "--help" | "-h")
      HELP_FUNC
      exit 1;
      ;;
    "--client" | "--user" | "-u")
      Client=true
      ;;
    "--server" | "-s")
      Server=true
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
    *)
    echo-red "$(Language INVALIDARGUMENT) $n"
      ;;
  esac
  i=$((i + 1))
  shift 1
done

    ### DISTRO LIST #########
    DistroFolder=""
  if [[ $DISTRO = *opensuse\ tumbleweed* ]]; then
    DistroFolder="opensuse-tumbleweed"
    PackageManager_openSUSE-TW

    External_PM_Brew
    External_PM_Flatpak
    External_PM_Snap
  elif [[ $DISTRO = *fedora* ]]; then
    DistroFolder="fedora"
    PackageManager_fedora

    External_PM_Brew
    External_PM_Flatpak
    External_PM_Snap
  elif [[ $DISTRO = *debian* ]]; then
    DistroFolder="debian"
    PackageManager_debian

    External_PM_Brew
    External_PM_Flatpak
    External_PM_Snap
  else
    echo -e "${Red}$(Language NOTSUPPORTDISTRO)${NoColor}"
    exit 1
  fi

if [ $Client = false ] && [ $Server = false ] && [ $Distrobox = false ]; then
  echo -e "${Red}$(Language NOARGUMENT)${NoColor}"
  exit 1;
else
    rootpassword
    if [ $Client = true ]; then
        if [ $Server = true ] || [ $Distrobox = true ]; then
            basic_if_warning
        fi
    elif [ $Server = true ] && [ $Distrobox = true ]; then
            basic_if_warning
    fi

    if [ $Client = true ] ; then
        RunScript "home" "${DistroFolder}"
    fi

    if [ $Server = true ]; then
        RunScript "server" "${DistroFolder}"
    fi

    if [ $Distrobox = true ] ; then
        RunScript_Distrobox "${DistroFolder}"
    fi
    rootpassword_end
fi
