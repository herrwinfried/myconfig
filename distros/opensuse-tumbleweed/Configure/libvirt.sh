#!/usr/bin/env bash
set -euo pipefail

	# Detect CPU vendor and set VT-d/IOMMU flags accordingly
	local VT_D
	local IOMMU
	cpu_vendor=$(grep -m1 '^vendor_id' /proc/cpuinfo | awk '{print $3}')
	if [[ "$cpu_vendor" == "GenuineIntel" ]]; then
		VT_D="intel_iommu=on"
		IOMMU="iommu=pt"
	elif [[ "$cpu_vendor" == "AuthenticAMD" ]]; then
		VT_D="amd_iommu=on"
		IOMMU="iommu=pt"
	else
		VT_D=""
		IOMMU=""
	fi

	local GRUB_FILE="/etc/default/grub"
	local CMDLINE_FILE="/etc/kernel/cmdline"

	local bootloader_type
	if [[ -f "$CMDLINE_FILE" ]]; then
		bootloader_type="bls"
	elif [[ -f "$GRUB_FILE" ]]; then
		bootloader_type="grub2"
	else
		bootloader_type="unknown"
	fi

	case "$bootloader_type" in
		bls)
			if is_command sdbootutil; then
				if [[ -f "$CMDLINE_FILE" ]]; then
					local current_cmdline=$(cat "$CMDLINE_FILE")
					if [[ "$current_cmdline" != *"$VT_D"* ]] || [[ "$current_cmdline" != *"$IOMMU"* ]]; then
						echo "$current_cmdline $VT_D $IOMMU" | sudo tee "$CMDLINE_FILE" > /dev/null
						color_echo Green "$(printf "$(_ "%s and %s parameters have been added to %s")" "$VT_D" "$IOMMU" "$CMDLINE_FILE")"
					else
						color_echo Yellow "$(printf "$(_ "%s and %s parameters are already in %s")" "$VT_D" "$IOMMU" "$CMDLINE_FILE")"
					fi
				else
					color_echo Red "$(printf "$(_ "%s not found!")" "$CMDLINE_FILE")"
				fi
				sudo sdbootutil update-all-entries
			fi
			;;
		grub2)
			if [[ -f "$GRUB_FILE" ]]; then
				local current_settings=$(grep -oP 'GRUB_CMDLINE_LINUX_DEFAULT="[^"]*"' "$GRUB_FILE" | cut -d'"' -f2)
				if [[ "$current_settings" != *"$VT_D"* ]] && [[ "$current_settings" != *"$IOMMU"* ]]; then
					sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"\(.*\)\"/GRUB_CMDLINE_LINUX_DEFAULT=\"\1 $VT_D $IOMMU\"/" "$GRUB_FILE"
					color_echo Green "$(printf "$(_ "%s and %s parameters have been added to the GRUB configuration.")" "$VT_D" "$IOMMU")"
				else
					color_echo Yellow "$(printf "$(_ "%s and %s parameters are already included in the GRUB configuration.")" "$VT_D" "$IOMMU")"
				fi
			else
				color_echo Red "$(_ "GRUB configuration file not found! Please check your system.")"
			fi
			;;
		*)
			color_echo Red "$(_ "Unsupported bootloader type.")"
			;;
	esac

	if rpm -q libvirt &> /dev/null; then
		sudo usermod -aG kvm,libvirt,input "$USER"
	fi

