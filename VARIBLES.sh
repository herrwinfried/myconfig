#!/bin/bash

Username="winfried"
HomePWD="/home/$Username"
Folder="MyConfig/files"
output="$HomePWD/$Folder"



# Colors
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
# Colors Finish

function checkroot {
if [[ $EUID -ne 0 ]]; then
     echo "$red Süper Kullanıcı/root olmanız gerekir. $white"
   exit 1
fi
}
function onlywsl(){
unameout=$(uname -r | tr '[:upper:]' '[:lower:]');
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
echo $yellow Sanırım WSL Distro kullanmıyorsunuz.$red İşlem iptal edildi. $white
exit 1
fi
}

function onlypc(){
unameout=$(uname -r | tr '[:upper:]' '[:lower:]');
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then
echo $yellow Sanırım Desktop kullanmıyorsunuz.$red İşlem iptal edildi. $white
exit 1
fi
}

function requirepackage() {
################REQUIRED##################################################################
packageList=""
if ! [ -x "$(command -v lsb_release)" ]; then
    echo "$yellow Dikkat ! lsb-release Paketi Bulunmadığından otomatik yüklenecek." >&2
  if [ -x "$(command -v apt)" ]; then
packageList+=" lsb-release"
elif [ -x "$(command -v zypper)" ]; then
packageList+=" lsb-release"
fi
fi

if ! [ -x "$(command -v git)" ]; then
    echo "$yellow Dikkat ! git Paketi Bulunmadığından otomatik yüklenecek." >&2
    if [ -x "$(command -v apt)" ]; then
packageList+=" git"
elif [ -x "$(command -v zypper)" ]; then
packageList+=" git"
fi
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "$yellow Dikkat ! wget Paketi Bulunmadığından otomatik yüklenecek." >&2
      if [ -x "$(command -v apt)" ]; then
packageList+=" wget"
elif [ -x "$(command -v zypper)" ]; then
packageList+=" wget"
fi
fi
if [ ! -z "$packageList" ]; then
      if [ -x "$(command -v apt)" ]; then
sudo apt install -y $packageList
elif [ -x "$(command -v zypper)" ]; then
sudo zypper --gpg-auto-import-keys install -y -l $packageList
fi
fi
################REQUIRED FINISH##################################################################
}