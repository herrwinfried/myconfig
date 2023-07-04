#!/bin/bash

package="libguestfs libguestfs-appliance"

if ! checkwsl; then
    package+=" qemu libvirt grubby"
fi

sudo $Package $PackageInstall $package
