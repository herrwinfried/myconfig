#!/bin/bash

package="libguestfs libguestfs-appliance"

if ! checkwsl; then
    package+=" qemu libvirt patterns-server-kvm_server patterns-server-kvm_tools"
fi

SUDO $Package $PackageInstall $package
