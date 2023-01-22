#!/bin/bash
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

checkroot
requirepackage

export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
. ./opensuse-tumbleweed.sh

#



##OPENSUSE TALİMATLARI BİTTİ
fi