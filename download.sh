#!/bin/bash
MainLine="linux"

. /etc/os-release

OS_Name=$NAME
OS_Version=$VERSION
distro=$(echo $OS_Name $OS_VERSION | tr '[:upper:]' '[:lower:]')

NEW_HOSTNAME="herrwinfried"

Username=$USER
HomePWD=$HOME
ExternalFolder="$HomePWD/myconfig/files"



if [ -d "myconfig" ]; then
rm -rf myconfig
fi

git clone https://github.com/herrwinfried/myconfig/ -b $MainLine

mkdir $ExternalFolder