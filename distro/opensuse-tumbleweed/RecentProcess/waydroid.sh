#!/bin/bash

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then

sudo grubby --update-kernel="/boot/vmlinuz-$(uname -r)" --args="psi=1"

fi