#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

openSUSETW_ALIAS

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
rpms
runs
bundles
appimages



