#!/bin/bash
MainLine="linux"

Username="winfried"
HomePWD="/home/$Username"
Folder="myconfig/files"
output="$HomePWD/$Folder"


if [ -d "myconfig" ]; then
rm -rf myconfig
fi

git clone https://github.com/herrwinfried/myconfig/ -b $MainLine

mkdir $output