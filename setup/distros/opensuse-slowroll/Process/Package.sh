#!/bin/bash

# Apple

Packages=("usbmuxd" "ifuse" "libimobiledevice-1_0-6" "libimobiledevice-glue-1_0-0" "libheif1" "libheif-ffmpeg" "libheif-jpeg" "libheif-openjpeg")
Delete_Packages=()

# KDE

if ! isWsl && [ "$(echo "$XDG_CURRENT_DESKTOP" | tr '[:upper:]' '[:lower:]')" = "kde" ]; then

    # Partition Manager, Clock App, Color for KDE, krecorder
    Packages+=("partitionmanager" "kclock" "colord-kde" "krecorder")

    Delete_Packages+=("kompare" "kuiviewer" "kmahjongg" "kmines" "kpat" "kreversi" "ksudoku" "akregator" "konversation" "ktnef" "pim-sieve-editor")
    
    # Mass renaming, Calendar, KDE Connect, Advanced Text Editor
    Packages+=("krename" "merkuro" "kdeconnect-kde" "kate")

    #  Search App, GPG GUI, Camera, Google Drive, discover flatpak support
    Packages+=("kfind" "kleopatra" "kamoso" "kio-gdrive" "discover-backend-flatpak")

    # Photo Browser, Color Picker, Sound Mixer
    Packages+=("gwenview" "kcolorchooser" "kmix")

    # Paint(Like WinXP), Music Player, Dolphin extra plugin, nextcloud images for dolphin
    Packages+=("kolourpaint" "elisa" "dolphin-plugins" "nextcloud-desktop-dolphin")

    # Video edit, File Usage viewer, Flatpak Theme xdg desktop portal, On-Screen Keyboard
    Packages+=("kdenlive" "filelight" "qt6-platformtheme-xdgdesktopportal" "maliit-keyboard")
fi

# Base

Packages+=("zsh" "htop" "wget" "curl" "rsync" "fastfetch" "hwinfo" "opi" "nano" "lsb-release" "jq" "poppler-tools")

PackagesFlatpak=("org.gtk.Gtk3theme.Breeze" "org.gtk.Gtk3theme.Adwaita-dark")

PackagesFlatpak+=("org.kde.WaylandDecoration.QAdwaitaDecorations//6.7" "org.kde.WaylandDecoration.QGnomePlatform-decoration//5.15-23.08" "org.kde.WaylandDecoration.QGnomePlatform-decoration//6.5")

PackagesFlatpak+=("com.github.tchx84.Flatseal")

if isWsl; then
    Packages+=()
else
    Packages+=("wl-clipboard" "xwaylandvideobridge" "memtest86+" "AdobeICCProfiles" "onboard")

    Packages+=("google-noto-sans*fonts" "google-noto-serif*fonts" "google-noto-coloremoji*fonts")

    Packages+=("patterns-cockpit" "myrlyn" "java-21-openjdk")

    Packages+=("anydesk" "teamviewer-suse" "brave-browser" "microsoft-edge-stable" "$(echo libreoffice-{base,writer,calc,impress,math,l10n-tr})" "$(echo droidcam{,-cli})")

    PackagesFlatpak+=("org.remmina.Remmina" "org.onlyoffice.desktopeditors" "org.localsend.localsend_app")

    Packages+=("$(echo libguestfs{,-appliance})" "$(echo virt{-install,-manager})" "qemu" "qemu-audio-pipewire" "virtualbox" "virtualbox-host-source")

    Packages+=("$(echo cups{,-client,-filters,-airprint})" "hplip-hpijs")

    Packages+=("$(echo mangohud{,-32bit})" "$(echo gamemode{,d})" "$(echo libgamemode0{,-32bit})" "$(echo libgamemodeauto0{,-32bit})" "steam" "lutris")

    PackagesFlatpak+=("com.usebottles.bottles" "com.heroicgameslauncher.hgl" "io.github.trigg.discover_overlay" "net.davidotek.pupgui2" "com.github.Matoking.protontricks" "org.freedesktop.Platform.VulkanLayer.MangoHud//23.08" "org.freedesktop.Platform.VulkanLayer.MangoHud//24.08" "org.freedesktop.Sdk.Extension.openjdk21//24.08" "org.prismlauncher.PrismLauncher")

    PackagesFlatpak+=("org.telegram.desktop" "im.riot.Riot")

    PackagesFlatpak+=("com.obsproject.Studio" "com.saivert.pwvucontrol" "com.stremio.Stremio")
fi

# Selinux

if is_command semanage; then
    Packages+=("$(echo python313-{semanage,setools,selinux})")
fi

# Container

if ! isWsl; then
    if lspci | grep -qi -E "nvidia|NVIDIA"; then
        Packages+=("nvidia-container-toolkit" "cuda")
    fi
    Packages+=("docker" "docker-compose" "podman" "distrobox")
fi

# Developer

if ! isWsl; then
    Packages+=("code" "sublime-merge" "filezilla" "okteta")
fi
Packages+=("rust" "dotnet-sdk-9.0" "aspnetcore-runtime-9.0" "dotnet-runtime-9.0" "krb5" "libicu77" "patterns-devel-mono-devel_mono" "python313")
Packages+=("python313-pip" "nodejs-default" "npm-default" "git" "git-lfs")

# Homebrew

OLD_PWD=$(pwd)
SUDO mkdir -p /home/linuxbrew/.linuxbrew
SUDO chown -R "$USER" /home/linuxbrew/.linuxbrew
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
cd "$OLD_PWD" && unset OLD_PWD

if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    /home/linuxbrew/.linuxbrew/bin/brew install oh-my-posh </dev/null
fi

# shellcheck disable=SC2124
package_list="${Packages[@]}"
# shellcheck disable=SC2124
unpackage_list="${Delete_Packages[@]}"
# shellcheck disable=SC2124
flatpak_list="${PackagesFlatpak[@]}"

PackageUnInstall "$unpackage_list"
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