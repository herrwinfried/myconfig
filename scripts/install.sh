#!/bin/bash
ScriptFolder=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ScriptFolder1=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)
. ./VARIBLES.sh 
rootpassword
HOME_ARG=0
SERVER_ARG=0
# CONTAINER_ARG=0
DISTROBOX_ARG=0
CONFIG_ARG=0
ONLYCONFIG_ARG=0
PRESETUP_ARG=0


basic_if_warning() {
  echo "$yellow Do you want to continue with both server and home arguments open?$white"
  echo "[1] Yes"
  echo "[2] No and exit"
  read IFREAD
  if [ $IFREAD -ne 1 ] && [ $IFREAD -ne 2 ]; then
    echo "$red You entered an unregistered number...$white"
    basic_if_warning
  elif [ $IFREAD -eq 2 ]; then
    exit 1
  fi
}

exe_script() {
  local script_folder="$1"
  for forScriptFile in $(ls -1 "$script_folder" | grep "\.sh$"); do
    echo -e "$magenta $forScriptFile $white\n" && sleep 1
    chmod +x "$script_folder/$forScriptFile"
    dos2unix "$script_folder/$forScriptFile"
    . "$script_folder/$forScriptFile"
  done
}
check_scriptfolder() {
  local folder="$1"
  local distro="$2"
  if [ -d "$ScriptFolder/$folder/$distro" ]; then
    return 0
  else
    return 1
  fi
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

i=1
j=$#

while [ $i -le $j ]; do
  n=$(echo $1 | tr '[:upper:]' '[:lower:]')
  case $n in
    "--help" | "-h")
      HELP_FUNC
      ;;
    "--presetup" | "-ps")
      PRESETUP_ARG=1
      ;;
    "--home" | "-u")
      HOME_ARG=1
      ;;
    "--server" | "-s")
      SERVER_ARG=1
      ;;
    "--distrobox" | "-d")
      DISTROBOX_ARG=1
      ;;
    "--config" | "-c")
      CONFIG_ARG=1
      ;;
    "--only-config" | "-cc")
      ONLYCONFIG_ARG=1
      ;;
    *)
      echo "$red Invalid argument-$i: $n $white"
      ;;
  esac
  i=$((i + 1))
  shift 1
done


function presetup_message {
      echo $yellow"I performed the presetup operations. Please restart your computer. The script has been terminated."
      echo $cyan"When you restart your computer, continue without the presetup parameter and the remaining operations will be completed."$white
      exit 1;
}
if [ $HOME_ARG -eq 0 ] && [ $SERVER_ARG -eq 0 ] && [ $DISTROBOX_ARG -eq 0 ] && [ $ONLYCONFIG_ARG -eq 0 ] && [ $CONFIG_ARG -eq 0 ] && [ $PRESETUP_ARG -eq 0 ]; then
  echo $yellow"You selected no arguments... I'm finishing the script...$white"
  exit 1;
else
  if [ $HOME_ARG -eq 1 ] && [ $SERVER_ARG -eq 1 ]; then
    basic_if_warning
  fi
  DistroFolder=""
  if [[ $distro = *opensuse\ tumbleweed* ]]; then
    DistroFolder="opensuse-tumbleweed"
    openSUSETW_ALIAS
    elif [[ $distro == *fedora* && $(rpm -E %fedora) -eq 39 ]]; then
    DistroFolder="fedora39"
    fedora_ALIAS
    elif [[ $distro = *debian* ]]; then
    DistroFolder="debian"
     debian_ALIAS
  else
    echo "$red I cannot support the operating system you are currently trying.$white"
    exit 1
  fi
    #
if [ $HOME_ARG -eq 1 ]; then
       if ! check_scriptfolder "home" "$DistroFolder"; then
        echo "NOT SUPPORT [home]"
        exit 1;
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/$DistroFolder/Repository"
      exe_script "$ScriptFolder/home/$DistroFolder/Presetup"
        presetup_message
    fi
    if [ $ONLYCONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/$DistroFolder/config"
      exit 1;
    fi
      exe_script "$ScriptFolder/home/$DistroFolder/Repository"
      exe_script "$ScriptFolder/home/$DistroFolder/FirstProcess"
      exe_script "$ScriptFolder/home/$DistroFolder/Package"
      exe_script "$ScriptFolder/home/$DistroFolder/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/$DistroFolder/config"
    fi
    fi
    fi

    if [ $SERVER_ARG -eq 1 ]; then
      if ! check_scriptfolder "server" "$DistroFolder"; then
        echo "NOT SUPPORT [server]"
        exit 1;
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/server/$DistroFolder/Repository"
      exe_script "$ScriptFolder/server/$DistroFolder/Presetup"
      presetup_message
    fi
    if [ $ONLYCONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/server/$DistroFolder/config"
      exit 1;
    fi
      exe_script "$ScriptFolder/server/$DistroFolder/Repository"
      exe_script "$ScriptFolder/server/$DistroFolder/FirstProcess"
      exe_script "$ScriptFolder/server/$DistroFolder/Package"
      exe_script "$ScriptFolder/server/$DistroFolder/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/server/$DistroFolder/config"
    fi
    fi
    fi

    if [ $DISTROBOX_ARG -eq 1 ]; then
   if ! check_scriptfolder "distrobox" "$DX_OS/$DistroFolder"; then
        echo "NOT SUPPORT [distrobox]"
        exit 1;
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/distrobox/$DX_OS/$DistroFolder/Repository"
      exe_script "$ScriptFolder/distrobox/$DX_OS/$DistroFolder/Presetup"
      presetup_message
    fi
    if [ $ONLYCONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/distrobox/$DX_OS/$DistroFolder/config"
      exit 1;
    fi
      exe_script "$ScriptFolder/distrobox/$DX_OS/$DistroFolder/Repository"
      exe_script "$ScriptFolder/distrobox/$DX_OS/$DistroFolder/FirstProcess"
      exe_script "$ScriptFolder/distrobox/$DX_OS/$DistroFolder/Package"
      exe_script "$ScriptFolder/distrobox/$DX_OS/$DistroFolder/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/distrobox/$DX_OS/$DistroFolder/config"
    fi
    fi
    fi
    #
  unset DistroFolder
fi

sudofinish