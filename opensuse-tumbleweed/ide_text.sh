#!/bin/bash

if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.27.1.13673.tar.gz
sudo tar -xzf jetbrains-toolbox-*.tar.gz -C /opt && sudo mv /opt/jetbrains-toolbox-* /opt/jetbrains-toolbox
sudo $PackageName $PackageInstall code filezilla
fi