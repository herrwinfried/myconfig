#!/bin/bash
ScriptFolder=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

if [[ $distro = *opensuse\ tumbleweed* ]]; then
openSUSETW_ALIAS

sudoreq
for forScriptFile in $(ls $ScriptFolder/distro/opensuse-tumbleweed/Repository )
do
	chmod +x $ScriptFolder/distro/opensuse-tumbleweed/Repository/$forScriptFile
    . $ScriptFolder/distro/opensuse-tumbleweed/Repository/$forScriptFile
done

for forScriptFile in $(ls $ScriptFolder/distro/opensuse-tumbleweed/Presetup )
do
    chmod +x $ScriptFolder/distro/opensuse-tumbleweed/Presetup/$forScriptFile
    . $ScriptFolder/distro/opensuse-tumbleweed/Presetup/$forScriptFile
done

sudofinish

else
echo "It is currently not compatible with your Operating system." && exit 1
fi