#!/bin/bash

function libvirt {
    if ! isWsl; then
        VT_D="intel_iommu=on"
        IOMMU="iommu=pt"
        GRUB_FILE="/etc/default/grub"

        if [ -f "$GRUB_FILE" ]; then
            CURRENT_SETTINGS=$(grep -oP 'GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"' "$GRUB_FILE" | cut -d'"' -f2)
            if [[ "$CURRENT_SETTINGS" != *"$VT_D"* ]] && [[ "$CURRENT_SETTINGS" != *"$IOMMU"* ]]; then
                SUDO sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $VT_D $IOMMU\"/" "$GRUB_FILE"
                echo -e "${COLORS[Green]}$VT_D and $IOMMU parameters have been added to the GRUB configuration.${COLORS[NoColor]}"
            else
                echo -e "${COLORS[Yellow]}$VT_D and $IOMMU parameters are already included in the GRUB configuration.${COLORS[NoColor]}"
            fi
        else
            echo -e "${COLORS[Red]}GRUB configuration file not found! Please check your system.${COLORS[NoColor]}"
        fi

        if rpm -q libvirt &>/dev/null; then
            SUDO sed -i "s/#user = \"qemu\"/user = \"$(id -gn)\"/g" /etc/libvirt/qemu.conf
            SUDO sed -i "s/#group = \"qemu\"/group = \"$(id -gn)\"/g" /etc/libvirt/qemu.conf
            SUDO grub2-mkconfig -o /boot/grub2/grub.cfg
            SUDO usermod -aG kvm,libvirt,input "$USER"
        fi
    fi
}

function virtualbox {
    if ! isWsl; then
        if rpm -q virtualbox &>/dev/null; then
            SUDO groupadd -f vboxusers
            SUDO usermod -aG vboxusers "$USER"
        fi
    fi
}

function nvidia {
    if ! isWsl; then
        if is_command nvidia-ctk; then
            SUDO nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
            nvidia-ctk runtime configure --runtime=docker --config=$HOME/.config/docker/daemon.json
            SUDO nvidia-ctk config --set nvidia-container-cli.no-cgroups --in-place
            if is_command setsebool; then
                SUDO setsebool -P container_use_devices true
            fi
        fi
    fi
}

function container {
    if is_command podman; then
        systemctl --user enable --now podman.service
        systemctl --user enable --now podman.socket
    fi

    if is_command distrobox && is_command podman; then
        USERHOME="/$HOME/distrobox"
        mkdir -p "$USERHOME"
        mkdir -p "$USERHOME/home/{fedora,debian}"
        distrobox-create -i fedora:latest -n fedora --nvidia --init -H "$USERHOME/home/fedora" -ap 'xdg-user-dirs systemd dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed"
        distrobox-create -i debian:latest -n debian --nvidia --init -H "$USERHOME/home/debian" -ap 'xdg-user-dirs systemd libpam-systemd dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed"
    fi
}

libvirt
virtualbox
nvidia
container
