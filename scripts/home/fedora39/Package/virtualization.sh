#!/bin/bash

package="libguestfs libguestfs-appliance"

if ! checkwsl; then
    package+=" qemu libvirt qemu-kvm"
    package+=" virt-install tigervnc libvirt-daemon-qemu tftp"
    package+=" libvirt-client libvirt-daemon-config-network libvirt-daemon-qemu virt-manager virt-v2v virt-viewer"
fi

SUDO $Package $PackageInstall $package
