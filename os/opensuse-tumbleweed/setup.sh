#!/bin/bash

### Fonts
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
### Finish

if [[ $EUID -ne 0 ]]; then
   echo "$red Süper Kullanıcı/Root Olmanız gerekiyor." 
   exit 1
fi
#################
#####lsb-core required##############################################
if ! [ -x "$(command -v lsb_release)" ]; then
    echo "$yellow Dikkat ! lsb-release Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y lsb-release
fi

if ! [ -x "$(command -v git)" ]; then
    echo "$yellow Dikkat ! git Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y git
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "$yellow Dikkat ! wget Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y wget
fi

if ! [ -x "$(command -v screenfetch)" ]; then
  echo "$yellow Dikkat ! screenfetch Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y screenfetch
fi

export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
#########FINISH###################
if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
###Only OpenSUSE TW
function scriptabort() {
echo "Bir sorun oldu." && exit 1
}
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
mkdir -p $ScriptLocal/files || scriptabort
wget https://raw.githubusercontent.com/herrwinfried/myconfig/main/os/opensuse-tumbleweed/install.sh -o install.sh && echo "$green İşlem tamamlandı. install.sh çalıştır. $white"

###TW Finish
fi 
