#!/usr/bin/env bash
# Process/Package.sh — Install application packages
set -euo pipefail

# ----------------------------------------------------------------
# Package lists
# ----------------------------------------------------------------
Packages=()
Delete_Packages=()
PackagesFlatpak=()

# --- Apple device support ---
Packages+=(
	"usbmuxd" "ifuse"
	"libimobiledevice-1_0-6" "libimobiledevice-glue-1_0-0"
	"libheif1" "libheif-ffmpeg" "libheif-jpeg" "libheif-openjpeg"
)

# --- Base tools ---
Packages+=(
	"zsh" "htop" "wget" "curl" "rsync" "fastfetch" "hwinfo"
	"opi" "nano" "lsb-release" "jq" "poppler-tools"
)

# --- System management ---
Packages+=("java-25-openjdk")


# --- Flatpak apps: Theme and tools ---
PackagesFlatpak+=(
	"org.gtk.Gtk3theme.Breeze" "org.gtk.Gtk3theme.Adwaita-dark"
	"com.github.tchx84.Flatseal"
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

# ----------------------------------------------------------------
# .NET post-installation configuration
# ----------------------------------------------------------------
if command -v dotnet >/dev/null 2>&1; then
	sudo dotnet workload update
	dotnet new install Avalonia.Templates
	sudo dotnet workload update

	# PowerShell
	sudo dotnet tool install --tool-path /opt/microsoft/tool powershell
	sudo chmod -R 555 /opt/microsoft/tool
	sudo ln -sf /opt/microsoft/tool/pwsh /usr/bin/pwsh
fi
