#!/bin/bash
ScriptFolder=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)
ScriptFolder1=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && cd .. && pwd)

. ./variable.sh 
CheckLinux

if [ ! -f "./lang/en.sh" ]; then
echo -e $red "language file missing!!!" $white
else

. ./lang/en.sh

fi
# Options
ARG_CLIENT=0
ARG_SERVER=0
ARG_DISTROBOX=0

ARG_PRESETUP=0

ARG_ONLYCONFIG=0
ARG_CONFIG=0

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
      ARG_CLIENT=1
      ;;
    "--server" | "-s")
      ARG_SERVER=1
      ;;
    "--distrobox" | "-d")
      ARG_DISTROBOX=1
      ;;
    "--presetup" | "-ps")
      ARG_PRESETUP=1
      ;;
    "--only-config" | "-cc")
      ARG_ONLYCONFIG=1
      ;;
    "--config" | "-c")
      ARG_CONFIG=1
      ;;
    *)
    red_message $LANG_INVALID_ARGUMENT: $n
      ;;
  esac
  i=$((i + 1))
  shift 1
done

basic_if_warning() {
  echo "$yellow $LANG_BOTH_WARNING_ARG $white"
  echo "[1] $LANG_BOTH_WARNING_ARG_YES"
  echo "[2] $LANG_BOTH_WARNING_ARG_NO"
  read IFREAD
  if [ $IFREAD -ne 1 ] && [ $IFREAD -ne 2 ]; then
    echo "$red $LANG_BOTH_WARNING_ARG_OPTION_INVALID $white"
    basic_if_warning
  elif [ $IFREAD -eq 2 ]; then
    exit 1
  fi
}

function presetup_message {
      echo $yellow $LANG_PRESETUP_MESSAGE_1
      echo $cyan $LANG_PRESETUP_MESSAGE_2 $white
      exit 1;
}

if [ $ARG_CLIENT -eq 0 ] && [ $ARG_SERVER -eq 0 ] && [ $ARG_DISTROBOX -eq 0 ]; then
  red_message $LANG_NO_ARGUMENTS
  exit 1;
else

rootpassword

    if [ $ARG_CLIENT -eq 1 ]; then
        if [ $ARG_SERVER -eq 1 ] || [ $ARG_DISTROBOX -eq 1 ]; then
            basic_if_warning
        fi

    elif [ $ARG_SERVER -eq 1 ] && [ $ARG_DISTROBOX -eq 1 ]; then
            basic_if_warning
    fi

    ### DISTRO LIST #########
    DistroFolder=""
  if [[ $DISTRO = *opensuse\ tumbleweed* ]]; then
    DistroFolder="opensuse-tumbleweed"
    PackageManager_openSUSE-TW

    External_PM_Brew
    External_PM_Flatpak
    External_PM_Snap
  else
    echo "$red $LANG_NOT_SUPPORT_DISTRO_LIST $white"
    exit 1
  fi

    ####
  if [ $ARG_CLIENT -eq 1 ]; then
       if ! CHECK_SHELL_DIRECTORY "home" "$DistroFolder"; then
        echo "NOT SUPPORT [home]"
        exit 1;
    else
    if [ $ARG_PRESETUP -eq 1 ]; then
      EXE_SHELL "$ScriptFolder/home/$DistroFolder/Repository"
      EXE_SHELL "$ScriptFolder/home/$DistroFolder/Presetup"
        presetup_message
    fi
    if [ $ARG_ONLYCONFIG -eq 1 ]; then
      EXE_SHELL "$ScriptFolder/home/$DistroFolder/config"
      exit 1;
    fi
      EXE_SHELL "$ScriptFolder/home/$DistroFolder/Repository"
      EXE_SHELL "$ScriptFolder/home/$DistroFolder/FirstProcess"
      EXE_SHELL "$ScriptFolder/home/$DistroFolder/Package"
      if [ $ARG_CONFIG -eq 1 ]; then
        EXE_SHELL "$ScriptFolder/home/$DistroFolder/config"
      fi
      EXE_SHELL "$ScriptFolder/home/$DistroFolder/RecentProcess"
    fi
    fi

    if [ $ARG_SERVER -eq 1 ]; then
      if ! CHECK_SHELL_DIRECTORY "server" "$DistroFolder"; then
        echo "NOT SUPPORT [server]"
        exit 1;
    else
    if [ $ARG_PRESETUP -eq 1 ]; then
      EXE_SHELL "$ScriptFolder/server/$DistroFolder/Repository"
      EXE_SHELL "$ScriptFolder/server/$DistroFolder/Presetup"
      presetup_message
    fi
    if [ $ARG_ONLYCONFIG -eq 1 ]; then
      EXE_SHELL "$ScriptFolder/server/$DistroFolder/config"
      exit 1;
    fi
      EXE_SHELL "$ScriptFolder/server/$DistroFolder/Repository"
      EXE_SHELL "$ScriptFolder/server/$DistroFolder/FirstProcess"
      EXE_SHELL "$ScriptFolder/server/$DistroFolder/Package"
      if [ $ARG_CONFIG -eq 1 ]; then
        EXE_SHELL "$ScriptFolder/server/$DistroFolder/config"
      fi
      EXE_SHELL "$ScriptFolder/server/$DistroFolder/RecentProcess"

    fi
    fi

    if [ $ARG_DISTROBOX -eq 1 ]; then
   if ! CHECK_SHELL_DIRECTORY "DISTRObox" "$DX_OS/$DistroFolder"; then
        echo "NOT SUPPORT [DISTRObox]"
        exit 1;
    else
    if [ $ARG_PRESETUP -eq 1 ]; then
      EXE_SHELL "$ScriptFolder/DISTRObox/$DX_OS/$DistroFolder/Repository"
      EXE_SHELL "$ScriptFolder/DISTRObox/$DX_OS/$DistroFolder/Presetup"
      presetup_message
    fi
    if [ $ARG_ONLYCONFIG -eq 1 ]; then
      EXE_SHELL "$ScriptFolder/DISTRObox/$DX_OS/$DistroFolder/config"
      exit 1;
    fi
      EXE_SHELL "$ScriptFolder/DISTRObox/$DX_OS/$DistroFolder/Repository"
      EXE_SHELL "$ScriptFolder/DISTRObox/$DX_OS/$DistroFolder/FirstProcess"
      EXE_SHELL "$ScriptFolder/DISTRObox/$DX_OS/$DistroFolder/Package"
      if [ $ARG_CONFIG -eq 1 ]; then
        EXE_SHELL "$ScriptFolder/DISTRObox/$DX_OS/$DistroFolder/config"
      fi
      EXE_SHELL "$ScriptFolder/DISTRObox/$DX_OS/$DistroFolder/RecentProcess"
    
    fi
    fi
    #
  unset DistroFolder  

fi

rootpassword_end
