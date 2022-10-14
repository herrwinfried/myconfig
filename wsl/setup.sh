#!/bin/bash

. ./varibles.sh
checkroot
. ./requirepackage.sh
requirePackage 0
########################ARGS##################################
powershell=0;
zypperdnf=0;
guivalue=0;
zypperdnfgui=0;
#########################
i=1;
j=$#;
while [ $i -le $j ]
do

if [[ $1 == "--powershell" ]] || [[ $1 == "-ps" ]]; then
powershell=1;
elif [[ $1 == "--dnf" ]]; then
zypperdnf=1;
elif [[ $1 == "--gui" ]]; then
guivalue=1;
zypperdnfgui=0;
elif [[ $1 == "--guidnf" ]]; then
guivalue=0;
zypperdnfgui=1;
    else
    echo "$red Invalid argument-$i: $1 $white";
    fi
    i=$((i + 1));
    shift 1;
done
if [[ $zypperdnf -eq 1 ]]; then
dnf_value=1
else
dnf_value=0
fi

if [[ $guivalue -eq 1 ]] && [[ $zypperdnfgui -eq 0 ]]; then
gui_value=1
elif [[ $guivalue -eq 0 ]] && [[ $zypperdnfgui -eq 1 ]]; then
gui_value=2
else
gui_value=0
fi
if [[ $powershell -eq 1 ]]; then
pwsh_value=1
else
pwsh_value=0
fi

#######################ARGS FINISH#########################



####OS SELECT
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')
#########FINISH###################
unameout=$(uname -r | tr '[:upper:]' '[:lower:]')
[[ ! -f /proc/cpuinfo ]] && echo "I couldn't find the /proc/cpuinfo file so the process was aborted." && exit 1
if [[ "$unameout" == "*microsoft*" || "$unameout" == "*wsl*" ]] \
|| cat /proc/cpuinfo | grep "microcode" | grep "0xffffffff" &>/dev/null
then
if [ "$distroselect" == "openSUSE Tumbleweed" ]; then

. ./opensuse.sh

opensuse_tw $dnf_value $gui_value $pwsh_value

# TW DNFVALUE GUIVALUE POWERSHELLVALUE

else
echo "The script does not yet support your operating system."
fi
fi