#!/bin/bash

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


for forScriptFile in $(ls $ScriptLocal/distro/opensuse-tumbleweed/FirstProcess )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/distro/opensuse-tumbleweed/FirstProcess/$forScriptFile
    . $ScriptLocal/distro/opensuse-tumbleweed/FirstProcess/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptLocal/distro/opensuse-tumbleweed/Repository )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/distro/opensuse-tumbleweed/Repository/$forScriptFile
    . $ScriptLocal/distro/opensuse-tumbleweed/Repository/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptLocal/distro/opensuse-tumbleweed/FirstPackage )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/distro/opensuse-tumbleweed/FirstPackage/$forScriptFile
    . $ScriptLocal/distro/opensuse-tumbleweed/FirstPackage/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptLocal/distro/opensuse-tumbleweed/Package )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/distro/opensuse-tumbleweed/Package/$forScriptFile
    . $ScriptLocal/distro/opensuse-tumbleweed/Package/$forScriptFile
done
#

rpms
runs
bundles
appimages

for forScriptFile in $(ls $ScriptLocal/distro/opensuse-tumbleweed/RecentProcess )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/distro/opensuse-tumbleweed/RecentProcess/$forScriptFile
    . $ScriptLocal/distro/opensuse-tumbleweed/RecentProcess/$forScriptFile
done
#


