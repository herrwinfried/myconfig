#!/bin/bash
MainLine="linux"

$USERNAME=$USER
$USERHOME=$HOME

ExternalFolder="$USERHOME/myconfig/files"

if [ -d "myconfig" ]; then
    rm -rf myconfig
fi

git clone https://github.com/herrwinfried/myconfig/ -b $MainLine

mkdir $ExternalFolder