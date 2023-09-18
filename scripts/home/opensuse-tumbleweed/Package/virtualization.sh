#!/bin/bash

package="libguestfs libguestfs-appliance"

if ! checkwsl; then
    package+=" qemu libvirt patterns-server-kvm_server patterns-server-kvm_tools grubby"
fi

SUDO zypper --gpg-auto-import-keys --no-gpg-checks addrepo https://download.opensuse.org/repositories/Virtualization/openSUSE_Tumbleweed/Virtualization.repo
SUDO zypper --gpg-auto-import-keys --no-gpg-checks refresh
SUDO $Package $PackageInstall $package
SUDO zypper --gpg-auto-import-keys --no-gpg-checks removerepo "Virtualization (openSUSE_Tumbleweed)"