#!/bin/bash
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. ./VARIBLES.SH

function brewInstall {
    brew install $1 < /dev/null
}

function brewInstallCask {
    brew install --cask $1 < /dev/null
}

function DMGInstall {
VOLUME=`hdiutil attach $1 | grep Volumes | cut -f3`
cp -rf $VOLUME/*.app /Applications
hdiutil detach $VOLUME
}

for forScriptFile in $(ls $ScriptLocal/macos/FirstProcess )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/macos/FirstProcess/$forScriptFile
    . $ScriptLocal/macos/FirstProcess/$forScriptFile
done
#

for forScriptFile in $(ls $ScriptLocal/macos/FirstPackage )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/macos/FirstPackage/$forScriptFile
    . $ScriptLocal/macos/FirstPackage/$forScriptFile
done
#


for forScriptFile in $(ls $ScriptLocal/macos/Package )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/macos/Package/$forScriptFile
    . $ScriptLocal/macos/Package/$forScriptFile
done
#

for forScriptFile in $(ls $ScriptLocal/macos/RecentProcess )
do
	echo $magenta $forScriptFile $white
	chmod +x $ScriptLocal/macos/RecentProcess/$forScriptFile
    . $ScriptLocal/macos/RecentProcess/$forScriptFile
done
#