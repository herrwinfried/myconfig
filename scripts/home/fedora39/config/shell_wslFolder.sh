#!/bin/bash
if ! checkwsl; then

    mkdir -p $HomePWD/source/
    mkdir -p $HomePWD/source/wProjects
    ln -s /mnt/wslFEDORA/home/winfried/wProjects $HomePWD/source/wProjects/wslProjects
    ln -s /mnt/wslFEDORA $HomePWD/source/wProjects/wslSUSE
    touch $HomePWD/source/wProjects/mount.sh
    echo "
#!/bin/bash

sudo dnf in -y libguestfs libguestfs-appliance

mkdir -p /mnt/wslFEDORA
Disk=XXXXX
WUser=winfried
guestmount --add /run/media/winfried/\$Disk/Users/\$WUser/wsl/fedora/ext4.vhdx --inspector --rw /mnt/wslFEDORA

" | tee $HomePWD/source/wProjects/mount.sh

fi
