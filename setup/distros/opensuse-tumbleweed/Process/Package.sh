#!/bin/bash

# Apple
Packages=("usbmuxd" "ifuse" "libimobiledevice-1_0-6" "libimobiledevice-glue-1_0-0" "libheif1" "libheif-ffmpeg" "libheif-jpeg" "libheif-openjpeg")

# KDE
if ! isWsl && [ "$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')" = "kde" ]; then

    # Partition Manager, Clock App, Color for KDE, krecorder
    Packages+=("partitionmanager" "kclock" "colord-kde" "krecorder")

    # Mass renaming, Calendar, KDE Connect, Advanced Text Editor
    Packages+=("krename" "merkuro" "kdeconnect-kde" "kate")

    #  Search App, GPG GUI, Camera, Google Drive, discover flatpak support
    Packages+=("kfind" "kleopatra" "kamoso" "kio-gdrive" "discover-backend-flatpak")

    # Photo Browser, Color Picker, Sound Mixer
    Packages+=("gwenview" "kcolorchooser" "kmix")

    # Paint(Like WinXP), Music Player, Dolphin extra plugin, nextcloud images for dolphin
    Packages+=("kolourpaint" "elisa" "dolphin-plugins" "nextcloud-desktop-dolphin")

    # Video edit, KDE Games, File Usage viewer, Flatpak Theme xdg desktop portal
    Packages+=("kdenlive" "patterns-kde-kde_games" "filelight" "qt6-platformtheme-xdgdesktopportal")
fi

# Base

Packages+=("zsh" "htop" "wget" "curl" "rsync" "fastfetch" "hwinfo" "opi" "nano" "lsb-release" "jq" "poppler-tools")

PackagesFlatpak=("org.gtk.Gtk3theme.Breeze" "org.gtk.Gtk3theme.Adwaita-dark")

PackagesFlatpak+=("org.kde.WaylandDecoration.QAdwaitaDecorations//6.7" "org.kde.WaylandDecoration.QGnomePlatform-decoration//5.15-23.08" "org.kde.WaylandDecoration.QGnomePlatform-decoration//6.5")

PackagesFlatpak+=("com.github.tchx84.Flatseal")

if isWsl; then
    Packages+=()
else
    Packages+=("wl-clipboard" "xwaylandvideobridge" "memtest86+" "AdobeICCProfiles")

    Packages+=("fetchmsttfonts" "google-noto-sans*fonts" "google-noto-serif*fonts" "google-noto-coloremoji*fonts")

    Packages+=("anydesk" "teamviewer-suse" "brave-browser" "microsoft-edge-stable" "libreoffice-base" "libreoffice-writer" "libreoffice-calc" "libreoffice-impress" "libreoffice-math" "libreoffice-l10n-tr")

    PackagesFlatpak+=("org.remmina.Remmina" "com.rustdesk.RustDesk" "org.onlyoffice.desktopeditors" "org.localsend.localsend_app")

    Packages+=("libguestfs" "libguestfs-appliance" "qemu" "qemu-audio-pipewire" "libvirt" "patterns-server-kvm_server" "patterns-server-kvm_tools" "virtualbox")

    Packages+=("patterns-server-printing" "skanlite" "cups" "cups-client" "cups-filters" "cups-airprint" "system-config-printer" "hplip")

    Packages+=("mangohud" "mangohud-32bit" "gamemode" "gamemoded" "libgamemode0" "libgamemodeauto0" "libgamemode0-32bit" "libgamemodeauto0-32bit" "steam" "lutris")

    PackagesFlatpak+=("com.usebottles.bottles" "com.heroicgameslauncher.hgl" "io.github.trigg.discover_overlay" "net.davidotek.pupgui2" "com.github.Matoking.protontricks" "org.freedesktop.Platform.VulkanLayer.MangoHud//23.08" "org.freedesktop.Platform.VulkanLayer.MangoHud//24.08" "org.freedesktop.Sdk.Extension.openjdk21//24.08" "org.prismlauncher.PrismLauncher")

    PackagesFlatpak+=("org.telegram.desktop" "im.riot.Riot")

    PackagesFlatpak+=("com.obsproject.Studio" "com.saivert.pwvucontrol" "com.stremio.Stremio")
fi

# Container
Packages+=("podman")
if ! isWsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        Packages+=("nvidia-container-toolkit")
    fi
    Packages+=("docker" "docker-compose" "podman" "distrobox")
fi

# Developer
if ! isWsl; then
    Packages+=("code" "sublime-merge" "filezilla" "okteta")
fi

Packages+=("patterns-devel-C-C++-devel_C_C++" "gdb" "clang" "gcc" "gcc-c++" "cmake" "cmake-full" "extra-cmake-modules")
Packages+=("dotnet-sdk-9.0" "aspnetcore-runtime-9.0" "dotnet-runtime-9.0" "krb5-devel" "zlib-devel" "patterns-devel-mono-devel_mono" "patterns-devel-base-devel_rpm_build" "python311")
Packages+=("python311-pip" "nodejs-default" "npm-default" "build" "ninja" "git" "git-lfs")

if ! isWsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        Packages+=("cuda")
    fi
fi

# Homebrew

OLD_PWD=$(pwd)

SUDO mkdir -p /home/linuxbrew/.linuxbrew
SUDO chown -R "$USER" /home/linuxbrew/.linuxbrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd "$OLD_PWD" && unset OLD_PWD

if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    /home/linuxbrew/.linuxbrew/bin/brew install oh-my-posh </dev/null
fi

package_list="${Packages[@]}"
flatpak_list="${PackagesFlatpak[@]}"

PackageInstall "$package_list"
FlatpakPackageInstall "$flatpak_list"

if [[ -x $(command -v dotnet) ]]; then
    SUDO dotnet workload update
    dotnet new install Avalonia.Templates
    SUDO dotnet workload update

    # Powershell
    SUDO dotnet tool install --tool-path /opt/microsoft/tool powershell
    SUDO ln -s /opt/microsoft/tool/pwsh /usr/bin/pwsh
fi

ExternalPackage
