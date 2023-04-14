#!/bin/bash
if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
mkdir -p /boot/grub2.d
mkdir -p /boot/grub2.d/themes
fi