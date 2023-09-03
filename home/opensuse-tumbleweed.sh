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


for forScriptFile in $(ls -1 $ScriptFolder/home/opensuse-tumbleweed/FirstProcess | grep "\.sh$" )
do

	echo -e $magenta $forScriptFile $white\n && sleep 1
	chmod +x $ScriptFolder/home/opensuse-tumbleweed/FirstProcess/$forScriptFile
    . $ScriptFolder/home/opensuse-tumbleweed/FirstProcess/$forScriptFile
done
#


for forScriptFile in $(ls -1 $ScriptFolder/home/opensuse-tumbleweed/Repository | grep "\.sh$" )
do

	echo -e $magenta $forScriptFile $white\n && sleep 1
	chmod +x $ScriptFolder/home/opensuse-tumbleweed/Repository/$forScriptFile
    . $ScriptFolder/home/opensuse-tumbleweed/Repository/$forScriptFile
done
#


for forScriptFile in $(ls -1 $ScriptFolder/home/opensuse-tumbleweed/FirstPackage | grep "\.sh$" )
do

	echo -e $magenta $forScriptFile $white\n && sleep 1
	chmod +x $ScriptFolder/home/opensuse-tumbleweed/FirstPackage/$forScriptFile
    . $ScriptFolder/home/opensuse-tumbleweed/FirstPackage/$forScriptFile
done
#


for forScriptFile in $(ls -1 $ScriptFolder/home/opensuse-tumbleweed/Package | grep "\.sh$" )
do

	echo -e $magenta $forScriptFile $white\n && sleep 1
	chmod +x $ScriptFolder/home/opensuse-tumbleweed/Package/$forScriptFile
    . $ScriptFolder/home/opensuse-tumbleweed/Package/$forScriptFile
done
#

for forScriptFile in $(ls -1 $ScriptFolder/home/opensuse-tumbleweed/RecentProcess | grep "\.sh$" )
do

	echo -e $magenta $forScriptFile $white\n && sleep 1
	chmod +x $ScriptFolder/home/opensuse-tumbleweed/RecentProcess/$forScriptFile
    . $ScriptFolder/home/opensuse-tumbleweed/RecentProcess/$forScriptFile
done
#

sudofinish