#!/bin/bash

package="qemu libvirt patterns-server-kvm_server patterns-server-kvm_tools libguestfs libguestfs-appliance"

if ! checkwsl ; then
package+=" grubby"
fi

sudo $Package $PackageInstall $package
