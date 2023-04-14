#!/bin/bash

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then

#sudo $PackageName $PackageInstall libgbinder1 python310-gbinder anbox-kmp-default liblxc1 lxc iptables dnsmasq

# sudo $PackageName $PackageInstall waydroid

# sudo systemctl enable --now waydroid-container
fi