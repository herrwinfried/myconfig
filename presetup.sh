#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. ./VARIBLES.sh

onlypc
checkroot
requirepackage


export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')

if [ "$distroselect" == "openSUSE Tumbleweed" ]; then

openSUSETW_ALIAS

for forScriptFile in $(ls $ScriptLocal/distro/opensuse-tumbleweed/Repository )
do
	chmod +x $ScriptLocal/distro/opensuse-tumbleweed/Repository/$forScriptFile
    . $ScriptLocal/distro/opensuse-tumbleweed/Repository/$forScriptFile
done

for forScriptFile in $(ls $ScriptLocal/distro/opensuse-tumbleweed/Restart_before )
do
    chmod +x $ScriptLocal/distro/opensuse-tumbleweed/Restart_before/$forScriptFile
    . $ScriptLocal/distro/opensuse-tumbleweed/Restart_before/$forScriptFile
done

else
echo "Şuan için senin İşletim sisteminle uyumlu değil." && exit 1
fi