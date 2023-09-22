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

function flatpakref {

	cdExternalFolder
    find . -iname '*.flatpakref' -exec chmod +x ./"{}" \;
	find . -iname '*.flatpakref' -exec $FlatpakPackage $FlatpakPackageInstall ./"{}" \;
	$FlatpakPackage $FlatpakPackageUpdate
}

function rpms {

	cdExternalFolder
    find . -iname '*.rpm' -exec chmod +x ./"{}" \;
	find . -iname '*.rpm' -exec $SUDO $Package $PackageInstall ./"{}" \;
    sudo $Package $PackageUpdate
}
function debs {

	cdExternalFolder
    find . -iname '*.deb' -exec chmod +x ./"{}" \;
	find . -iname '*.deb' -exec $SUDO $Package $PackageInstall ./"{}" \;
    sudo $Package $PackageUpdate
}

function runs {
	cdExternalFolder
	find . -iname '*.run' -exec chmod +x ./"{}" \;
	find . -iname '*.run' -exec $SUDO ./"{}" \;
}

function bundles {
	cdExternalFolder
	find . -iname "*.bundle" -exec chmod +x ./"{}" \;
	find . -iname "*.bundle" -exec $SUDO ./"{}" \;

}

function appimages {

	cdExternalFolder
	find . -iname "*.appimage" -exec chmod +x ./"{}" \;
	find . -iname "*.appimage" -exec sudo ./"{}" \;
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
    *)
      echo "$red Invalid argument-$i: $n $white"
      ;;
  esac
  i=$((i + 1))
  shift 1
done

if [ $HOME_ARG -eq 0 ] && [ $SERVER_ARG -eq 0 ] && [ $DISTROBOX_ARG -eq 0 ] && [ $CONFIG_ARG -eq 0 ]; then
  echo $yellow"You selected no arguments... I'm finishing the script...$white"
  exit 1;
else
  if [ $HOME_ARG -eq 1 ] && [ $SERVER_ARG -eq 1 ]; then
    basic_if_warning
  fi

  if [[ $distro = *opensuse\ tumbleweed* ]]; then
  openSUSETW_ALIAS
    if [ $HOME_ARG -eq 1 ]; then
         if ! check_scriptfolder "home" "opensuse-tumbleweed"; then
        echo "NOT SUPPORT [home]"
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/opensuse-tumbleweed/Repository"
      exe_script "$ScriptFolder/home/opensuse-tumbleweed/Presetup"
      echo $yellow"I performed the presetup operations. Please restart your computer. The script has been terminated."
      echo $cyan"When you restart your computer, continue without the presetup parameter and the remaining operations will be completed."$white
      exit 1;
    fi
      exe_script "$ScriptFolder/home/opensuse-tumbleweed/Repository"
      exe_script "$ScriptFolder/home/opensuse-tumbleweed/FirstProcess"
      exe_script "$ScriptFolder/home/opensuse-tumbleweed/Package"
      exe_script "$ScriptFolder/home/opensuse-tumbleweed/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/opensuse-tumbleweed/config"
    fi
    fi
    fi

    if [ $SERVER_ARG -eq 1 ]; then
       if ! check_scriptfolder "server" "opensuse-tumbleweed"; then
        echo "NOT SUPPORT [server]"
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/server/opensuse-tumbleweed/Repository"
      exe_script "$ScriptFolder/server/opensuse-tumbleweed/Presetup"
      echo $yellow"I performed the presetup operations. Please restart your computer. The script has been terminated."
      echo $cyan"When you restart your computer, continue without the presetup parameter and the remaining operations will be completed."$white
      exit 1;
    fi
      exe_script "$ScriptFolder/server/opensuse-tumbleweed/Repository"
      exe_script "$ScriptFolder/server/opensuse-tumbleweed/FirstProcess"
      exe_script "$ScriptFolder/server/opensuse-tumbleweed/Package"
      exe_script "$ScriptFolder/server/opensuse-tumbleweed/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/server/opensuse-tumbleweed/config"
    fi
    fi
    fi

    if [ $DISTROBOX_ARG -eq 1 ]; then
      if ! check_scriptfolder "distrobox" "opensuse-tumbleweed"; then
        echo "NOT SUPPORT [distrobox]"
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
    echo "NOT SUPPORT [distrobox.presetup]"
    fi
      exe_script "$ScriptFolder/distrobox/opensuse-tumbleweed/Repository"
      exe_script "$ScriptFolder/distrobox/opensuse-tumbleweed/FirstProcess"
      exe_script "$ScriptFolder/distrobox/opensuse-tumbleweed/Package"
      exe_script "$ScriptFolder/distrobox/opensuse-tumbleweed/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/distrobox/opensuse-tumbleweed/config"
    fi
    fi
    fi

    elif [[ $distro = *fedora* ]]; then
    fedora_ALIAS
    if [ $HOME_ARG -eq 1 ]; then
       if ! check_scriptfolder "home" "fedora"; then
        echo "NOT SUPPORT [home]"
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/fedora/Repository"
      exe_script "$ScriptFolder/home/fedora/Presetup"
      echo $yellow"I performed the presetup operations. Please restart your computer. The script has been terminated."
      echo $cyan"When you restart your computer, continue without the presetup parameter and the remaining operations will be completed."$white
      exit 1;
    fi
      exe_script "$ScriptFolder/home/fedora/Repository"
      exe_script "$ScriptFolder/home/fedora/FirstProcess"
      exe_script "$ScriptFolder/home/fedora/Package"
      exe_script "$ScriptFolder/home/fedora/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/fedora/config"
    fi
    fi
    fi

    if [ $SERVER_ARG -eq 1 ]; then
      if ! check_scriptfolder "server" "fedora"; then
        echo "NOT SUPPORT [server]"
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/server/fedora/Repository"
      exe_script "$ScriptFolder/server/fedora/Presetup"
      echo $yellow"I performed the presetup operations. Please restart your computer. The script has been terminated."
      echo $cyan"When you restart your computer, continue without the presetup parameter and the remaining operations will be completed."$white
      exit 1;
    fi
      exe_script "$ScriptFolder/server/fedora/Repository"
      exe_script "$ScriptFolder/server/fedora/FirstProcess"
      exe_script "$ScriptFolder/server/fedora/Package"
      exe_script "$ScriptFolder/server/fedora/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/server/fedora/config"
    fi
    fi
    fi

    if [ $DISTROBOX_ARG -eq 1 ]; then
   if ! check_scriptfolder "distrobox" "fedora"; then
        echo "NOT SUPPORT [distrobox]"
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
    echo "NOT SUPPORT [distrobox.presetup]"
    fi
      exe_script "$ScriptFolder/distrobox/fedora/Repository"
      exe_script "$ScriptFolder/distrobox/fedora/FirstProcess"
      exe_script "$ScriptFolder/distrobox/fedora/Package"
      exe_script "$ScriptFolder/distrobox/fedora/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/distrobox/fedora/config"
    fi
    fi
    fi
     elif [[ $distro = *debian* ]]; then
     debian_ALIAS
        if [ $HOME_ARG -eq 1 ]; then
       if ! check_scriptfolder "home" "debian"; then
        echo "NOT SUPPORT [home]"
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/debian/Repository"
      exe_script "$ScriptFolder/home/debian/Presetup"
      echo $yellow"I performed the presetup operations. Please restart your computer. The script has been terminated."
      echo $cyan"When you restart your computer, continue without the presetup parameter and the remaining operations will be completed."$white
      exit 1;
    fi
      exe_script "$ScriptFolder/home/debian/Repository"
      exe_script "$ScriptFolder/home/debian/FirstProcess"
      exe_script "$ScriptFolder/home/debian/Package"
      exe_script "$ScriptFolder/home/debian/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/home/debian/config"
    fi
    fi
    fi

    if [ $SERVER_ARG -eq 1 ]; then
      if ! check_scriptfolder "server" "debian"; then
        echo "NOT SUPPORT [server]"
    else
    if [ $PRESETUP_ARG -eq 1]; then
      exe_script "$ScriptFolder/server/debian/Repository"
      exe_script "$ScriptFolder/server/debian/Presetup"
      echo $yellow"I performed the presetup operations. Please restart your computer. The script has been terminated."
      echo $cyan"When you restart your computer, continue without the presetup parameter and the remaining operations will be completed."$white
      exit 1;
    fi
      exe_script "$ScriptFolder/server/debian/Repository"
      exe_script "$ScriptFolder/server/debian/FirstProcess"
      exe_script "$ScriptFolder/server/debian/Package"
      exe_script "$ScriptFolder/server/debian/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/server/debian/config"
    fi
    fi
    fi

    if [ $DISTROBOX_ARG -eq 1 ]; then
   if ! check_scriptfolder "distrobox" "debian"; then
        echo "NOT SUPPORT [distrobox]"
    else
    if [ $PRESETUP_ARG -eq 1 ]; then
    echo "NOT SUPPORT [distrobox.presetup]"
    fi
      exe_script "$ScriptFolder/distrobox/debian/Repository"
      exe_script "$ScriptFolder/distrobox/debian/FirstProcess"
      exe_script "$ScriptFolder/distrobox/debian/Package"
      exe_script "$ScriptFolder/distrobox/debian/RecentProcess"

      if [ $CONFIG_ARG -eq 1 ]; then
      exe_script "$ScriptFolder/distrobox/debian/config"
    fi
    fi
    fi

  else
    echo "$red I cannot support the operating system you are currently trying.$white"
  fi
fi

sudofinish
