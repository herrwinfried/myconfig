#!/bin/bash

SUDO $Package $PackageInstall dnf libdnf-repo-config-zypp python3-dnf-plugin-versionlock python3-dnf-plugins-core
SUDO dnf makecache -y && SUDO zypper --gpg-auto-import-keys refresh

if [ "$(cat /etc/dnf/dnf.conf | grep protect_running_kernel)" ]; then
    echo -e "${Red}$(Language dnfprotect_running_kernel)${NoColor}"
else
    SUDO su -c "echo "protect_running_kernel=False" | tee -a /etc/dnf/dnf.conf"
fi

SUDO dnf versionlock exclude suse-prime