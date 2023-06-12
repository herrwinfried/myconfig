#!/bin/bash

ScriptFolder_FEDORA=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

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


for forScriptFile in $(ls $ScriptFolder/home/fedora/FirstProcess )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/home/fedora/FirstProcess/$forScriptFile
    . $ScriptFolder/home/fedora/FirstProcess/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptFolder/home/fedora/Repository )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/home/fedora/Repository/$forScriptFile
    . $ScriptFolder/home/fedora/Repository/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptFolder/home/fedora/FirstPackage )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/home/fedora/FirstPackage/$forScriptFile
    . $ScriptFolder/home/fedora/FirstPackage/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptFolder/home/fedora/Package )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/home/fedora/Package/$forScriptFile
    . $ScriptFolder/home/fedora/Package/$forScriptFile
done
#

for forScriptFile in $(ls $ScriptFolder/home/fedora/RecentProcess )
do
sudoreq
	echo $magenta $forScriptFile $white && sleep 3
	chmod +x $ScriptFolder/home/fedora/RecentProcess/$forScriptFile
    . $ScriptFolder/home/fedora/RecentProcess/$forScriptFile
done
#

sudofinish