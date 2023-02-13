#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

PackageName="zypper --gpg-auto-import-keys"
RPMArg="--no-gpg-checks"
PackageInstall="install -y -l"
UpdateArg="dup -y"
PackageRemove="remove -y"
FlatpakInstall="flatpak install -y flathub"
SnapInstall="snap install"

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

for TWSCRIPT in $(ls $ScriptLocal/opensuse-tumbleweed )
do
    . $ScriptLocal/opensuse-tumbleweed/$TWSCRIPT
done

rpms
runs
bundles
appimages



