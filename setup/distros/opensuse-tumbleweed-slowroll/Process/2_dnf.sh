#!/bin/bash

SUDO zypper --gpg-auto-import-keys --no-gpg-checks install -y -l dnf5 libdnf-repo-config-zypp
SUDO dnf5 makecache -y && SUDO zypper --gpg-auto-import-keys refresh

if [ "$(cat /etc/dnf/dnf.conf | grep protect_running_kernel)" ]; then
    echo -e "${COLORS[Red]}$(Language dnfprotect_running_kernel)${COLORS[NoColor]}"
else
    SUDO su -c "echo "protect_running_kernel=False" | tee -a /etc/dnf/dnf.conf"
fi

SUDO dnf5 versionlock exclude suse-prime

SUDO ln -sf $(which dnf5) /usr/bin/dnf