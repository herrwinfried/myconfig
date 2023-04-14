#!/bin/bash


if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
sudo hostnamectl set-hostname $HOSTNAME_NEW
fi