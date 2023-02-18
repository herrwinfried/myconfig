#!/bin/bash
MainLine="linux"

Username="winfried"
HomePWD="/home/$Username"
Folder="MyConfig/files"
output="$HomePWD/$Folder"


unzipName="$HomePWD/MyConfig/myconfig-$MainLine"

if [ -d "old" ]
then
rm -rf old
fi

if [ -d "$HomePWD/MyConfig" ]
then

echo "$output/MyConfig mevcut..."
else
mkdir -p $output/MyConfig
fi

if [ -d "$output" ]
then
mv $output old
mkdir -p $output
echo "$output mevcut..."
else
mkdir -p $output
fi

cd $HomePWD

wget https://github.com/herrwinfried/myconfig/archive/refs/heads/$MainLine.zip -O MyConfig.zip
unzip MyConfig.zip -d MyConfig && mv $unzipName/* $HomePWD/MyConfig && rm -rf $unzipName
rm -rf $HomePWD/MyConfig.zip
