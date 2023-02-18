#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

onlypc
checkroot
requirepackage


export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
if [ "$distroselect" == "openSUSE Tumbleweed" ]; then

openSUSETW_ALIAS

for TWSCRIPT in $(ls $ScriptLocal/opensuse-tumbleweed/Restart_before )
do
    chmod +x $ScriptLocal/opensuse-tumbleweed/Restart_before/$TWSCRIPT
    . $ScriptLocal/opensuse-tumbleweed/Restart_before/$TWSCRIPT
done

else
echo "Şuan için senin İşletim sisteminle uyumlu değil." && exit 1
fi