#!/bin/bash
if ! checkwsl; then

    mkdir -p $HomePWD/source/
    mkdir -p $HomePWD/source/wProjects
    ln -s /mnt/wslFedora/home/winfried/wProjects $HomePWD/source/wProjects/wslProjects
    ln -s /mnt/wslFedora $HomePWD/source/wProjects/wslFedora
    touch $HomePWD/source/wProjects/mount.sh
    echo "
#!/bin/bash

sudo dnf in -y libguestfs libguestfs-appliance

mkdir -p /mnt/wslFedora
Disk=XXXXX
WUser=winfried
guestmount --add /run/media/winfried/\$Disk/Users/\$WUser/wsl/fedora/ext4.vhdx --inspector --rw /mnt/wslFedora

" | tee $HomePWD/source/wProjects/mount.sh

fi
