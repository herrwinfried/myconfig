#!/bin/bash

package="qemu libvirt libguestfs libguestfs-appliance"

if ! checkwsl; then
    package+=" grubby"
fi

sudo $Package $PackageInstall $package
