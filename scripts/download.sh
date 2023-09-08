#!/bin/bash
MainLine="linux"

Username=$USER
HomePWD=$HOME
ExternalFolder="$HomePWD/myconfig/files"

if [ -d "myconfig" ]; then
    rm -rf myconfig
fi

git clone https://github.com/herrwinfried/myconfig/ -b $MainLine

mkdir $ExternalFolder
