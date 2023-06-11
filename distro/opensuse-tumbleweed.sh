#!/bin/bash

ScriptFolder_TW=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

function flatpakref {

	cdExternalFolder
    find . -iname '*.flatpakref' -exec chmod +x ./"{}" \;
	find . -iname '*.flatpakref' -exec $FlatpakPackage $FlatpakPackageInstall ./"{}" \;
	$FlatpakPackage $FlatpakPackageUpdate
}

function rpms {

	cdExternalFolder
    find . -iname '*.rpm' -exec chmod +x ./"{}" \;
	find . -iname '*.rpm' -exec sudo $Package $PackageInstall ./"{}" \;
    sudo $Package $PackageUpdate
}

function runs {
	cdExternalFolder
	find . -iname '*.run' -exec chmod +x ./"{}" \;
	find . -iname '*.run' -exec sudo ./"{}" \;
}

function bundles {
	cdExternalFolder
	find . -iname "*.bundle" -exec chmod +x ./"{}" \;
	find . -iname "*.bundle" -exec sudo ./"{}" \;

}

function appimages {

	cdExternalFolder
	find . -iname "*.appimage" -exec chmod +x ./"{}" \;
	find . -iname "*.appimage" -exec sudo ./"{}" \;
}


for forScriptFile in $(ls $ScriptFolder/distro/opensuse-tumbleweed/FirstProcess )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/distro/opensuse-tumbleweed/FirstProcess/$forScriptFile
    . $ScriptFolder/distro/opensuse-tumbleweed/FirstProcess/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptFolder/distro/opensuse-tumbleweed/Repository )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/distro/opensuse-tumbleweed/Repository/$forScriptFile
    . $ScriptFolder/distro/opensuse-tumbleweed/Repository/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptFolder/distro/opensuse-tumbleweed/FirstPackage )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/distro/opensuse-tumbleweed/FirstPackage/$forScriptFile
    . $ScriptFolder/distro/opensuse-tumbleweed/FirstPackage/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptFolder/distro/opensuse-tumbleweed/Package )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/distro/opensuse-tumbleweed/Package/$forScriptFile
    . $ScriptFolder/distro/opensuse-tumbleweed/Package/$forScriptFile
done
#

for forScriptFile in $(ls $ScriptFolder/distro/opensuse-tumbleweed/RecentProcess )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/distro/opensuse-tumbleweed/RecentProcess/$forScriptFile
    . $ScriptFolder/distro/opensuse-tumbleweed/RecentProcess/$forScriptFile
done
#

sudofinish