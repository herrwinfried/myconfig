#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

. ./VARIBLES.sh

checkroot
requirepackage


export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')

if [ "$distroselect" == "openSUSE Tumbleweed" ]; then

openSUSETW_ALIAS

for forScriptFile in $(ls $ScriptLocal/distro/opensuse-tumbleweed/config )
do
	chmod +x $ScriptLocal/distro/opensuse-tumbleweed/config/$forScriptFile
    . $ScriptLocal/distro/opensuse-tumbleweed/config/$forScriptFile
done

else
echo "Şuan için senin İşletim sisteminle uyumlu değil." && exit 1
fi