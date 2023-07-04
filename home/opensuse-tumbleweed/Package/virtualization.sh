#!/bin/bash

package="libguestfs libguestfs-appliance"

if ! checkwsl; then
    package+=" qemu libvirt patterns-server-kvm_server patterns-server-kvm_tools grubby"
fi

sudo $Package $PackageInstall $package
if ! checkwsl; then
sudo usermod -aG kvm,libvirt,input $Username
sudo grubby --update-kernel=ALL --args="intel_iommu=on"
sudo grubby --update-kernel=ALL --args="iommu=pt" 
fi