#!/bin/bash
GitB="main"
FolderName="myscripts_1"
FolderScript="files"
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
 #  exit 1
fi
#################
#####lsb-core required##############################################
if ! [ -x "$(command -v lsb_release)" ]; then
    echo "$yellow Dikkat ! redhat-lsb-core Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install -y redhat-lsb-core
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "$yellow Dikkat ! wget Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install -y wget
fi

export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
#########FINISH###################
if [ "$distroselect" == "Fedora release 37 (Thirty Seven)" ]; then
###Only OpenSUSE TW
function scriptabort() {
echo "Bir sorun oldu." && exit 1
}
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


mkdir -p $ScriptLocal/$FolderName || scriptabort

if [ -d "$ScriptLocal/$FolderName" ] 
then
cd $ScriptLocal/$FolderName
sudo rm -rf *
fi

mkdir -p $ScriptLocal/$FolderName/$FolderScript || scriptabort

if [ -d "$ScriptLocal/$FolderName" ] 
then
cd $ScriptLocal/$FolderName

wget https://raw.githubusercontent.com/herrwinfried/myconfig/$GitB/os/fedora/nvidia.sh
wget https://raw.githubusercontent.com/herrwinfried/myconfig/$GitB/os/fedora/setup.sh && echo "$green İşlem tamamlandı. setup.sh çalıştır. $white"
rm -rf *.1
sudo chmod 777 *
if [ -d "$ScriptLocal/$FolderName/$FolderScript" ]
then
cd $ScriptLocal/$FolderName/$FolderScript
sudo chmod 777 *
fi
fi

###TW Finish
fi 
