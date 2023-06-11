#!/bin/bash
ScriptFolder=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. ./VARIBLES.sh

if [[ $distro = *opensuse\ tumbleweed* ]]; then
openSUSETW_ALIAS

sudoreq
for forScriptFile in $(ls $ScriptFolder/distro/opensuse-tumbleweed/config )
do
	chmod +x $ScriptFolder/distro/opensuse-tumbleweed/config/$forScriptFile
    . $ScriptFolder/distro/opensuse-tumbleweed/config/$forScriptFile
done
sudofinish

else
echo "It is currently not compatible with your Operating system." && exit 1
fi