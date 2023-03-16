#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

openSUSETW_ALIAS

mkdir -p /boot/grub2.d
mkdir -p /boot/grub2.d/themes

function checkFolder {
mkdir -p $output
cd $output
}

function rpms {

	checkFolder
    find . -iname '*.rpm' -exec chmod +x ./"{}" \;
	find . -iname '*.rpm' -exec $PackageName $RPMArg $PackageInstall ./"{}" \;
    sudo $PackageName $UpdateArg
}
function runs {
	checkFolder
	find . -iname '*.run' -exec chmod +x ./"{}" \;
	find . -iname '*.run' -exec sudo ./"{}" \;
}
function bundles {
	checkFolder
	find . -iname "*.bundle" -exec chmod +x ./"{}" \;
	find . -iname "*.bundle" -exec sudo ./"{}" \;

}
function appimages {

	checkFolder
	find . -iname "*.appimage" -exec chmod +x ./"{}" \;
	find . -iname "*.appimage" -exec sudo ./"{}" \;
}

for TWSCRIPT in $(ls $ScriptLocal/opensuse-tumbleweed/Repo )
do
	chmod +x $ScriptLocal/opensuse-tumbleweed/Repo/$TWSCRIPT
    . $ScriptLocal/opensuse-tumbleweed/Repo/$TWSCRIPT
done
#
for TWSCRIPT in $(ls $ScriptLocal/opensuse-tumbleweed/FirstPackage )
do
	chmod +x $ScriptLocal/opensuse-tumbleweed/FirstPackage/$TWSCRIPT
    . $ScriptLocal/opensuse-tumbleweed/FirstPackage/$TWSCRIPT
done
#
for TWSCRIPT in $(ls $ScriptLocal/opensuse-tumbleweed/Package )
do
	chmod +x $ScriptLocal/opensuse-tumbleweed/Package/$TWSCRIPT
    . $ScriptLocal/opensuse-tumbleweed/Package/$TWSCRIPT
done
#
ln -s /usr/lib64/libraw.so.23 /usr/lib64/libraw.so.20
ln -s /usr/lib64/libraw.so.23.0.0 /usr/lib64/libraw.so.20.0.0
ln -s /usr/lib64/libraw_r.so.23 /usr/lib64/libraw_r.so.20
ln -s /usr/lib64/libraw_r.so.23.0.0 /usr/lib64/libraw_r.so.20.0.0

rpms
runs
ln -s /etc/sysconfig /etc/init.d
bundles
appimages



