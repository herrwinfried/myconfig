# 1. Create a Btrfs Disk and Volume

1. Create a Btrfs disk.
2. Open a Btrfs volume named `/home`.
3. Complete the setup.

# 2. Post-Installation

```bash
sudo grub2-editenv - unset menu_auto_hide

sudo btrfs filesystem label / FEDORA
```
### Optional: Use DNF Mirror
```bash
cat >> /etc/dnf/dnf.conf <<EOF
fastestmirror=True
max_parallel_downloads=10
EOF
```

# 2.1 Post-Installation
```bash
sudo dnf clean all && sudo dnf makecache -y
sudo dnf install -y git inotify-tools make
sudo dnf update -y && sudo reboot
```
# 3. Set Up Btrfs Subvolumes

```bash
sudo mkdir -vp /var/lib/libvirt

ROOT_UUID="$(sudo grub2-probe --target=fs_uuid /)"

OPTIONS="$(grep '/home' /etc/fstab \
    | awk '{print $4}' \
    | cut -d, -f2-)"

SUBVOLUMES=(
    "opt"
    "var/cache"
    "var/crash"
    "var/lib/libvirt/images"
    "var/log"
    "var/spool"
    "var/tmp"
    "var/www"
)

MAX_LEN="$(printf '/%s\n' "${SUBVOLUMES[@]}" | wc -L)"

for dir in "${SUBVOLUMES[@]}" ; do
    if [[ -d "/${dir}" ]] ; then
        sudo mv -v "/${dir}" "/${dir}-old"
        sudo btrfs subvolume create "/${dir}"
        sudo cp -ar "/${dir}-old/." "/${dir}/"
    else
        sudo btrfs subvolume create "/${dir}"
    fi
    sudo restorecon -RF "/${dir}"
    printf "%-41s %-${MAX_LEN}s %-5s %-s %-s\n" \
        "UUID=${ROOT_UUID}" \
        "/${dir}" \
        "btrfs" \
        "subvol=${dir},${OPTIONS}" \
        "0 0" | \
        sudo tee -a /etc/fstab
done

sudo chown -cR $USER:$USER /home/$USER/

sudo systemctl daemon-reload && sudo mount -va

for dir in "${SUBVOLUMES[@]}" ; do
    if [[ -d "/${dir}-old" ]] ; then
        sudo rm -rvf "/${dir}-old"
    fi
done
```

# 4. Install Snapper

```bash
sudo dnf install -y snapper python3-dnf-plugin-snapper

sudo snapper -c root create-config /
sudo snapper -c root set-config ALLOW_USERS=$USER SYNC_ACL=yes

sudo snapper -c home create-config /home
sudo snapper -c home set-config ALLOW_USERS=$USER SYNC_ACL=yes

sudo systemctl daemon-reload && sudo mount -va

SUBVOLUMES=(
    "home/.snapshots"
    ".snapshots"
)

MAX_LEN="$(printf '/%s\n' "${SUBVOLUMES[@]}" | wc -L)"

for dir in "${SUBVOLUMES[@]}" ; do
    if [[ -d "/${dir}" ]] ; then
        sudo mv -v "/${dir}" "/${dir}-old"
        sudo btrfs subvolume create "/${dir}"
        sudo cp -ar "/${dir}-old/." "/${dir}/"
    else
        sudo btrfs subvolume create "/${dir}"
    fi
    sudo restorecon -RF "/${dir}"
    printf "%-41s %-${MAX_LEN}s %-5s %-s %-s\n" \
        "UUID=${ROOT_UUID}" \
        "/${dir}" \
        "btrfs" \
        "subvol=${dir},${OPTIONS}" \
        "0 0" | \
        sudo tee -a /etc/fstab
done

echo 'PRUNENAMES = ".snapshots"' | sudo tee -a /etc/updatedb.conf

echo 'SUSE_BTRFS_SNAPSHOT_BOOTING="true"' | sudo tee -a /etc/default/grub

sudo sed -i '1i set btrfs_relative_path="yes"' /boot/efi/EFI/fedora/grub.cfg

sudo grub2-mkconfig -o /boot/grub2/grub.cfg
```

# 5. Install Grub-Btrfs

```bash
git clone https://github.com/Antynea/grub-btrfs

cd grub-btrfs

sed -i \
-e '/#GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS/a \
GRUB_BTRFS_SNAPSHOT_KERNEL_PARAMETERS="systemd.volatile=state"' \
-e '/#GRUB_BTRFS_GRUB_DIRNAME/a \
GRUB_BTRFS_GRUB_DIRNAME="/boot/grub2"' \
-e '/#GRUB_BTRFS_MKCONFIG=/a \
GRUB_BTRFS_MKCONFIG=/usr/sbin/grub2-mkconfig' \
-e '/#GRUB_BTRFS_SCRIPT_CHECK=/a \
GRUB_BTRFS_SCRIPT_CHECK=grub2-script-check' \
config

sudo make install

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

sudo systemctl enable --now grub-btrfsd.service

cd ..

rm -rvf grub-btrfs
```

# 6. Create a System Root Snapshot and Set It as the Default

```bash
sudo mkdir -v /.snapshots/1

cat > /.snapshots/1/info.xml <<EOF
<?xml version="1.0"?>
<snapshot>
  <type>single</type>
  <num>1</num>
  <date>$(date -u +"%F %T")</date>
  <description>first root subvolume</description>
</snapshot>
EOF

sudo btrfs subvolume snapshot / /.snapshots/1/snapshot

SNAP_1_ID="$(sudo btrfs inspect-internal rootid /.snapshots/1/snapshot)"

sudo btrfs subvolume set-default ${SNAP_1_ID} /

sudo btrfs subvolume get-default /
```