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

# --- KDE desktop packages ---
if [[ "$(echo "${XDG_CURRENT_DESKTOP:-}" | tr '[:upper:]' '[:lower:]')" == "kde" ]]; then
	Packages+=(
		# Partition Manager, Clock App, Color for KDE, Krecorder
		"partitionmanager" "kclock" "colord-kde" "krecorder"
		# Mass renaming, Calendar, KDE Connect, Advanced Text Editor
		"krename" "merkuro" "kdeconnect-kde" "kate"
		# Search App, GPG GUI, Camera, Google Drive, Discover flatpak support
		"kfind" "kleopatra" "kamoso" "kio-gdrive" "discover-backend-flatpak"
		# Photo Browser, Color Picker, Sound Mixer
		"gwenview" "kcolorchooser" "kmix"
		# Paint (Like WinXP), Music Player, Dolphin extra plugin, Nextcloud
		"kolourpaint" "elisa" "dolphin-plugins" "nextcloud-desktop-dolphin"
		# Video edit, File Usage viewer, Flatpak Theme xdg desktop portal
		"kdenlive" "filelight" "qt6-platformtheme-xdgdesktopportal"
	)
	Delete_Packages+=("konversation")
fi

# --- Base tools ---
Packages+=(
	"zsh" "htop" "wget" "curl" "rsync" "fastfetch" "hwinfo"
	"opi" "nano" "lsb-release" "jq" "poppler-tools"
	"wl-clipboard" "memtest86+"
)

# --- Fonts ---
Packages+=("google-noto-sans*fonts" "google-noto-serif*fonts" "google-noto-coloremoji*fonts")

# --- System management ---
Packages+=("patterns-cockpit" "myrlyn" "java-25-openjdk")

# --- Browser and office ---
Packages+=(
	"brave-browser"
	libreoffice-{base,writer,calc,impress,math,l10n-tr}
	droidcam{,-cli}
)

# --- Flatpak apps: Theme and tools ---
PackagesFlatpak+=(
	"org.gtk.Gtk3theme.Breeze" "org.gtk.Gtk3theme.Adwaita-dark"
	"com.github.tchx84.Flatseal"
)

# --- Flatpak apps: Productivity ---
PackagesFlatpak+=("org.remmina.Remmina" "org.onlyoffice.desktopeditors" "org.localsend.localsend_app")

# --- Network and virtualization ---
Packages+=(
	"wireshark"
	libguestfs{,-appliance}
	virt{-install,-manager}
	"qemu" "qemu-audio-pipewire"
)

# --- Printer ---
Packages+=(cups{,-client,-filters,-airprint} "hplip-hpijs")

# --- Gaming ---
Packages+=(
	mangohud{,-32bit}
	gamemode{,d}
	libgamemode0{,-32bit}
	libgamemodeauto0{,-32bit}
	"steam"
)
PackagesFlatpak+=(
	"com.usebottles.bottles" "com.heroicgameslauncher.hgl"
	"io.github.trigg.discover_overlay" "net.davidotek.pupgui2"
	"com.github.Matoking.protontricks"
	"org.freedesktop.Platform.VulkanLayer.MangoHud//25.08"
	"org.freedesktop.Sdk.Extension.openjdk25//25.08"
	"org.prismlauncher.PrismLauncher"
)

# --- Communication ---
PackagesFlatpak+=("org.telegram.desktop" "im.riot.Riot")

# --- Media ---
PackagesFlatpak+=("com.obsproject.Studio" "com.saivert.pwvucontrol" "com.stremio.Stremio")

# --- SELinux ---
if is_command semanage; then
	Packages+=(python313-{semanage,setools,selinux} "setools-gui")
fi

# --- Container ---
if lspci | grep -qi -E "nvidia|NVIDIA"; then
	Packages+=("nvidia-container-toolkit")
fi
Packages+=("docker" "docker-compose" "podman" "distrobox")

# --- Developer tools ---
Packages+=("code" "filezilla")
PackagesFlatpak+=("md.obsidian.Obsidian" "io.dbeaver.DBeaverCommunity")

Packages+=("dotnet-sdk-10.0" "dotnet-runtime-10.0" "krb5" "libicu")
Packages+=("git" "git-lfs" "glab" "gh")

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
