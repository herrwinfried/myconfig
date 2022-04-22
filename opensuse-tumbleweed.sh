#!/bin/bash

ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
. ./VARIBLES.sh

PackageName="zypper --gpg-auto-import-keys"
RPMArg="--no-gpg-checks"
PackageInstall="install -y -l"
UpdateArg="dup -y"

onlypc

function x_nvidia_part(){
    sudo prime-select offload-set intel
    sudo prime-select offload
    sudo systemctl enable nvidia-hibernate.service nvidia-suspend.service nvidia-resume.service
}

function checkFolder {
mkdir -p $output
cd $output
}
function rpms {

	checkFolder
    find . -iname '*.rpm' -exec chmod +x ./"{}" \;
	find . -iname '*.rpm' -exec $PackageName $RPMArg $PackageInstall ./"{}" \;
    sudo $PackageName $UpdateArg
}
function runs {
	checkFolder
	find . -iname '*.run' -exec chmod +x ./"{}" \;
	find . -iname '*.run' -exec sudo ./"{}" \;
}
function bundles {
	checkFolder
	find . -iname "*.bundle" -exec chmod +x ./"{}" \;
	find . -iname "*.bundle" -exec sudo ./"{}" \;

}
function appimages {

	checkFolder
	find . -iname "*.appimage" -exec chmod +x ./"{}" \;
	find . -iname "*.appimage" -exec sudo ./"{}" \;
}

function repository {
sudo zypper --gpg-auto-import-keys addrepo -cfp 90 'https://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/' packman
sudo zypper --gpg-auto-import-keys refresh
sudo zypper dist-upgrade -y --from packman --allow-vendor-change
#######################################################################################################
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
#######################################################################################################
sudo zypper --gpg-auto-import-keys install -y curl
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
sudo zypper --gpg-auto-import-keys addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
#######################################################################################################
sudo zypper --gpg-auto-import-keys install -y libicu
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
wget https://packages.microsoft.com/config/opensuse/15/prod.repo
sudo mv prod.repo /etc/zypp/repos.d/microsoft-prod.repo
sudo chown root:root /etc/zypp/repos.d/microsoft-prod.repo

#sudo zypper --gpg-auto-import-keys addrepo -fc https://packages.microsoft.com/config/sles/15/mssql-server-preview.repo

#######################################################################################################
sudo rpm --import https://www.mongodb.org/static/pgp/server-6.0.asc
sudo zypper addrepo --gpgcheck "https://repo.mongodb.org/zypper/suse/15/mongodb-org/6.0/x86_64/" mongodb
#######################################################################################################
zypper --non-interactive --quiet addrepo --refresh -p 90  http://download.opensuse.org/repositories/server:database:postgresql/openSUSE_Tumbleweed/ PostgreSQL
#######################################################################################################
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/zypp/repos.d/vscode.repo'
#######################################################################################################
cat > AnyDesk-OpenSUSE.repo << "EOF"
[anydesk]
name=AnyDesk OpenSUSE - stable
baseurl=http://rpm.anydesk.com/opensuse/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
zypper --gpg-auto-import-keys addrepo --repo AnyDesk-OpenSUSE.repo
#######################################################################################################
zypper ar --priority 50 --refresh https://download.opensuse.org/repositories/home:/luke_nukem:/asus/openSUSE_Tumbleweed/ asus-linux
#######################################################################################################
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
}
function kde_function {
    zypper addrepo https://download.opensuse.org/repositories/home:hopeandtruth6517:kirigami-apps/openSUSE_Tumbleweed/home:hopeandtruth6517:kirigami-apps.repo
    sudo $PackageName $UpdateArg
## Music
    sudo flatpak install -y flathub org.kde.vvave
### partitionmanager, kclock, digikam,colord-kde, Ses kayıt edici, Video oynatıcı, Metin düzenleyici , Dosya yöneticisi , KDIFF, Takvim, kdeconnect, dosya bulucu, GPG , kamera, kde IDE, KDE IDE PHP VE QT , Google Drive KDE
    sudo $PackageName $PackageInstall partitionmanager kclock digikam colord-kde krecorder dragonplayer kwrite krename kdiff3 kalendar kdeconnect-kde kate kfind kleopatra kamoso kdevelop5 kdevelop5-plugin-php kdevelop5-pg-qt kio-gdrive
## YT Music QT
    sudo flatpak install -y flathub org.kde.audiotube
}

function basepackage {
sudo zypper --gpg-auto-import-keys install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs
sudo $PackageName remove -y tlp
    sudo $PackageName $PackageInstall dracula-gtk-theme fetchmsttfonts powerline-fonts AdobeICCProfiles \
neofetch screenfetch onboard hwinfo htop ffmpeg redshift zsh git curl wget lsb-release \
discord brave-browser pinta flameshot gimp \
zsh curl neofetch git opi lzip unzip e2fsprogs nano systemd-zram-service power-profiles-daemon
#openshot
    sudo flatpak install -y flathub org.telegram.desktop
    sudo flatpak install -y flathub io.github.mimbrero.WhatsAppDesktop
    sudo snap install authy
    sudo snap install termius-app
    sudo flatpak install -y flathub org.onlyoffice.desktopeditors

kde_function
sudo $PackageName $PackageInstall anydesk
sudo systemctl enable zramswap.service

sudo mkdir -p /etc/systemd/system/bluetooth.service.d
sudo touch /etc/systemd/system/bluetooth.service.d/override.conf
echo "[Service]
ExecStart=
ExecStart=/usr/libexec/bluetooth/bluetoothd -E" >> /etc/systemd/system/bluetooth.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart bluetooth
}

function x_powershell {
sudo $PackageName $UpdateArg
sudo $PackageName $PackageInstall curl tar libicu72 libopenssl1_0_0 jq
pwshcore=$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest| jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")

curl -L $pwshcore -o /tmp/powershell.tar.gz
sudo mkdir -p /opt/microsoft/powershell
sudo tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
sudo ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
sudo chmod +x /usr/bin/pwsh
}

function x_ohmyposh {
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh

mkdir $HomePWD/.poshthemes
wget https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/powerlevel10k_rainbow.omp.json -O $HomePWD/.poshthemes/powerlevel10k_rainbow.omp.json
chmod u+rw $HomePWD/.poshthemes/*.omp.*
}

function apple_device {
    sudo $PackageName $PackageInstall ifuse libimobiledevice-1_0-6 libimobiledevice-devel usbmuxd libimobiledevice-glue-1_0-0
}
function asus_community {
sudo $PackageName $PackageInstall asusctl asusctl-rog-gui
sudo systemctl enable --now supergfxd.service
sudo systemctl enable --now asusd.service
sudo systemctl start --now supergfxd.service
sudo systemctl start --now asusd.service
sudo
}
function dnfsetup {
sudo zypper --gpg-auto-import-keys install -y dnf rpm-repos-openSUSE-Tumbleweed
sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
sudo dnf makecache -y && sudo zypper --gpg-auto-import-keys refresh

}
function flatpakSetup {
sudo $PackageName $PackageInstall flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

function snapSetup {
  sudo $PackageName $PackageInstall snapd
  sudo systemctl enable --now snapd && sudo systemctl enable --now snapd.apparmor
  sudo systemctl start --now snapd && sudo systemctl start --now snapd.apparmor
}
function printers {
sudo $PackageName $PackageInstall skanlite cups cups-client cups-filters system-config-printer skanlite system-config-printer hplip
	#sudo adduser $home lpadmin
	sudo service cups start
	sudo systemctl start cups
	sudo systemctl enable cups
}
function ide_text {
    wget https://download.jetbrains.com/toolbox/jetbrains-toolbox-1.27.1.13673.tar.gz
    sudo tar -xzf jetbrains-toolbox-*.tar.gz -C /opt && sudo mv /opt/jetbrains-toolbox-* /opt/jetbrains-toolbox
	sudo $PackageName $PackageInstall code filezilla
}
function game_video {
	sudo $PackageName $PackageInstall lutris minetest steam gamemoded libgamemode0 libgamemodeauto0 obs-studio kdenlive 
	sudo flatpak install -y flathub com.usebottles.bottles
}
function developerpackage {

sudo $PackageName $PackageInstall \
apache2 php8 php8-mysql apache2-mod_php8 mariadb mariadb-tools mongodb-org nodejs-default npm-default php-composer2 \
dotnet-sdk-6.0 llvm-clang gcc gcc-c++ cmake cmake-full extra-cmake-modules rsync gdb ninja \
patterns-devel-base-devel_basis patterns-devel-C-C++-devel_C_C++ \
gtk3-devel \
java-18-openjdk \
patterns-kde-devel_kde_frameworks patterns-kde-devel_qt5 desktop-file-utils #patterns-devel-base-devel_rpm_build #patterns-devel-mono-devel_mono
##Config

    mkdir -p ~/data/db
    a2enmod php8
    sudo echo "AddType application/x-httpd-php .php" >> /etc/apache2/mod_mime-defaults.conf

##Config FINISH
sudo $PackageName $PackageInstall podman
sudo flatpak install -y flathub io.podman_desktop.PodmanDesktop

}
sudo $PackageName $UpdateArg
x_nvidia_part
repository
dnfsetup
snapSetup
flatpakSetup
asus_community
basepackage
apple_device

x_powershell
x_ohmyposh

rpms
runs
bundles
appimages

printers
ide_text
game_video
developerpackage

