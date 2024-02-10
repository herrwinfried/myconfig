#!/bin/bash
if ! checkwsl; then

    mkdir -p $HomePWD/source/
    mkdir -p $HomePWD/source/wProjects
    ln -s /mnt/wslSUSE/home/winfried/wProjects $HomePWD/source/wProjects/wslProjects
    ln -s /mnt/wslSUSE $HomePWD/source/wProjects/wslSUSE
    touch $HomePWD/source/wProjects/mount.sh
    echo "
#!/bin/bash

sudo zypper in -y libguestfs libguestfs-appliance

mkdir -p /mnt/wslSUSE
Disk=XXXXX
WUser=winfried
guestmount --add /run/media/winfried/\$Disk/Users/\$WUser/AppData/Local/Packages/46932SUSE.openSUSETumbleweed_022rs5jcyhyac/LocalState/ext4.vhdx --inspector --rw /mnt/wslSUSE

" | tee $HomePWD/source/wProjects/mount.sh

fi
