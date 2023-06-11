#!/bin/bash

sudo $Package $PackageInstall dnf libdnf-repo-config-zypp python3-dnf-plugin-versionlock python3-dnf-plugins-core
sudo dnf makecache -y && sudo zypper --gpg-auto-import-keys refresh

if [ "$(cat /etc/dnf/dnf.conf | grep protect_running_kernel)" ]; then
echo $red"protect_running_kernel is available. The value will be not written.$white"
else
echo "protect_running_kernel=False" | sudo tee -a /etc/dnf/dnf.conf
fi

if [ "$(cat /etc/dnf/dnf.conf | grep excludepkgs)" ]; then
echo $red"excludepkgs is available. The value will be not written.$white"
else
echo "excludepkgs=suse-prime" | sudo tee -a /etc/dnf/dnf.conf
fi