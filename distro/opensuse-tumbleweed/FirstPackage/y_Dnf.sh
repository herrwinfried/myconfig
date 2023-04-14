#!/bin/bash

sudo zypper --gpg-auto-import-keys install -y dnf libdnf-repo-config-zypp
sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
sudo dnf makecache -y && sudo zypper --gpg-auto-import-keys refresh

echo "protect_running_kernel=False" >> /etc/dnf/dnf.conf