#!/bin/bash

function x_nvidia_part(){
    sudo prime-select offload-set intel
    sudo prime-select offload
    sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service
}


#if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
#
#fi