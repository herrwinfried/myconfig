#!/usr/bin/env bash
# Process/Package.sh — Install application packages
set -euo pipefail

# ----------------------------------------------------------------
# Package lists
# ----------------------------------------------------------------
Packages=()
Delete_Packages=()
PackagesFlatpak=()

# --- Base tools ---
Packages+=(
	"git" "zsh" "htop" "wget" "curl" "rsync" "fastfetch" "hwinfo"
	"nano" "jq"
)

# ----------------------------------------------------------------
# Homebrew installation
# ----------------------------------------------------------------
sudo mkdir -p /home/linuxbrew/.linuxbrew
sudo chown -R "$USER" /home/linuxbrew/.linuxbrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
	/home/linuxbrew/.linuxbrew/bin/brew install oh-my-posh </dev/null
fi

# ----------------------------------------------------------------
# Package installation/removal
# ----------------------------------------------------------------
if [[ ${#Delete_Packages[@]} -gt 0 ]]; then
	PackageUnInstall "${Delete_Packages[@]}"
fi

PackageInstall "${Packages[@]}"
FlatpakPackageInstall "${PackagesFlatpak[@]}"