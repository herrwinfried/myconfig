#!/bin/bash

function libvirt {
    if ! isWsl; then
        VT_D="intel_iommu=on"
        IOMMU="iommu=pt"
        GRUB_FILE="/etc/default/grub"
        CMDLINE_FILE="/etc/kernel/cmdline"

        if [[ -f $CMDLINE_FILE ]]; then
            BOOTLOADER_TYPE="bls"
        elif [[ -f $GRUB_FILE ]]; then
            BOOTLOADER_TYPE="grub2"
        else
            BOOTLOADER_TYPE="unkdown"
        fi

        case "$BOOTLOADER_TYPE" in
        bls)
            if command -v sdbootutil &>/dev/null; then
                if [ -f "$CMDLINE_FILE" ]; then
                    CURRENT_CMDLINE=$(cat "$CMDLINE_FILE")
                    if [[ "$CURRENT_CMDLINE" != *"$VT_D"* ]] || [[ "$CURRENT_CMDLINE" != *"$IOMMU"* ]]; then
                        echo "$CURRENT_CMDLINE $VT_D $IOMMU" | sudo tee "$CMDLINE_FILE" >/dev/null
                        echo -e "${COLORS[Green]}$VT_D and $IOMMU parameters have been added to $CMDLINE_FILE${COLORS[NoColor]}"
                    else
                        echo -e "${COLORS[Yellow]}$VT_D and $IOMMU parameters are already in $CMDLINE_FILE${COLORS[NoColor]}"
                    fi
                else
                echo -e "${COLORS[Red]}$CMDLINE_FILE not found!${COLORS[NoColor]}"
                fi
                SUDO sdbootutil update-all-entries                
            fi
            ;;
        grub2)
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
            ;;
        *)
            echo "Not support"
            ;;
        esac
        if rpm -q libvirt &>/dev/null; then
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
        distrobox-create -i fedora:latest -n fedora --nvidia --init -H "$USERHOME/home/fedora" -ap 'xdg-user-dirs systemd dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed-slowroll"
        distrobox-create -i debian:latest -n debian --nvidia --init -H "$USERHOME/home/debian" -ap 'xdg-user-dirs systemd libpam-systemd dos2unix' --additional-flags "--env DX_OS=opensuse-tumbleweed-slowroll"
    fi
}

libvirt
virtualbox
nvidia
container
