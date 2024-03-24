#!/bin/bash

if ! checkwsl; then
    package="libguestfs libguestfs-appliance qemu libvirt patterns-server-kvm_server patterns-server-kvm_tools"
    SUDO $Package $PackageInstall $package
fi


