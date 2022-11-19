#!/bin/bash
PackageName="zypper --gpg-auto-import-keys"
RPMArg="--no-gpg-checks"
PackageInstall="install -y"
UpdateArg="dup -y"


FolderName="myscripts_1"
FolderScript="files"


#######COLOR###################
termcols=$(tput cols)
bold="$(tput bold)"
fontnormal="$(tput init)"
fontreset="$(tput reset)"
underline="$(tput smul)"
standout="$(tput smso)"
normal="$(tput sgr0)"
black="$(tput setaf 0)"
red="$(tput setaf 1)"
green="$(tput setaf 2)"
yellow="$(tput setaf 3)"
blue="$(tput setaf 4)"
magenta="$(tput setaf 5)"
cyan="$(tput setaf 6)"
white="$(tput setaf 7)"
#######FINISH###################


################REQUIRED##################################################################
if [[ $EUID -ne 0 ]]; then
   echo "$red Süper Kullanıcı/Root Olmanız gerekiyor."
   exit 1
fi
if ! [ -x "$(command -v lsb_release)" ]; then
    echo "$yellow Dikkat ! lsb-release Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y lsb-release
fi

if ! [ -x "$(command -v git)" ]; then
    echo "$yellow Dikkat ! git Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y git
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "$yellow Dikkat ! wget Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y wget
fi


################REQUIRED FINISH##################################################################
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')


if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#

function checkFolder {
mkdir -p $ScriptLocal/$FolderName/$FolderScript
cd $ScriptLocal/$FolderName/$FolderScript
}
function rpms {

	checkFolder
	sudo $PackageName $RPMArg $PackageInstall ./*.rpm
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
    flatpak install -y flathub org.kde.vvave
### Ses kayıt edici, Video oynatıcı, Metin düzenleyici , Dosya yöneticisi , KDIFF, Takvim, kdeconnect, To do, dosya bulucu, kamera, kde IDE
    sudo $PackageName $PackageInstall krecorder dragonplayer Kwrite krename kdiff3 kalendar kdeconnect-kde kate kfind kleopatra kamoso kdevelop5 kdevelop5-plugin-php kdevelop5-pg-qt
## YT Music QT
    flatpak install -y flathub org.kde.audiotube
}

function fonts {
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /usr/share/fonts/truetype
fc-cache
}

function kuro {
    sudo rm -rf kuro.rpm
    sudo rm -rf kuro
    kuroinfo=$(curl -s https://api.github.com/repos/davidsmorais/kuro/releases/latest| jq -r ".assets[] | select(.name | test(\"x86_64.rpm\")) | .browser_download_url")
curl -L $kuroinfo -o /tmp/kuro.rpm
unzip /tmp/kuro.rpm && cd /tmp/kuro && cd opt && mv * /opt/ && cd /tmp/kuro && mv usr /usr/
}
function basepackage {
sudo zypper --gpg-auto-import-keys install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs

    sudo $PackageName $PackageInstall fetchmsttfonts powerline-fonts \
neofetch screenfetch onboard hwinfo htop ffmpeg redshift zsh git curl wget lsb-release \
discord brave-browser pinta openshot flameshot gimp \
zsh curl neofetch git opi lzip unzip e2fsprogs nano systemd-zram-service

    flatpak install -y flathub org.telegram.desktop
    flatpak install -y flathub io.github.mimbrero.WhatsAppDesktop
    sudo snap install authy

kde_function
sudo $PackageName $PackageInstall anydesk
kuro
sudo mkdir -p /etc/systemd/system/bluetooth.service.d
sudo touch /etc/systemd/system/bluetooth.service.d/override.conf
echo "[Service]
ExecStart=
ExecStart=/usr/libexec/bluetooth/bluetoothd -E" >> /etc/systemd/system/bluetooth.service.d/override.conf
sudo systemctl daemon-reload
sudo systemctl restart bluetooth
}

function powershells {
sudo $PackageName $UpdateArg
sudo $PackageName $PackageInstall curl tar libicu60_2 libopenssl1_0_0
sudo $PackageName $PackageInstall jq
susepwshcore=$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest| jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")

curl -L $susepwshcore -o /tmp/powershell.tar.gz
sudo mkdir -p /opt/microsoft/powershell
sudo tar -xzf /tmp/powershell.tar.gz -C /opt/microsoft/powershell/
sudo ln -s /opt/microsoft/powershell/pwsh /usr/bin/pwsh
sudo chmod +x /usr/bin/pwsh
}

function ohmyposhs {
sudo wget https://github.com/JanDeDobbeleer/oh-my-posh/releases/latest/download/posh-linux-amd64 -O /usr/local/bin/oh-my-posh
sudo chmod +x /usr/local/bin/oh-my-posh
}

function apples {
    sudo $PackageName $PackageInstall libimobiledevice-1_0-6 libimobiledevice-devel usbmuxd
}
function asus_pack {
sudo $PackageName $PackageInstall asusctl asusctl-rog-gui
}
function dnfsetup {
sudo zypper --gpg-auto-import-keys install -y dnf rpm-repos-openSUSE-Tumbleweed 
sudo zypper --gpg-auto-import-keys install -y libdnf-repo-config-zypp PackageKit-backend-dnf
sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
sudo dnf makecache -y && sudo zypper --gpg-auto-import-keys refresh

}
function flatpak {
sudo $PackageName $PackageInstall flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

function snapx {
  sudo $PackageName $PackageInstall snapd
  sudo systemctl enable --now snapd
  sudo systemctl enable --now snapd.apparmor  
  sudo systemctl start --now snapd
  sudo systemctl start --now snapd.apparmor 
}
function printers {
sudo $PackageName $PackageInstall skanlite cups cups-client cups-filters system-config-printer skanlite system-config-printer hplip
	#sudo adduser $home lpadmin
	sudo service cups start
	sudo systemctl start cups
	sudo systemctl enable cups
}
function ide_text {
	sudo $PackageName $PackageInstall code filezilla
}
function game_video {
	sudo $PackageName $PackageInstall lutris minetest steam gamemoded obs-studio kdenlive
	#sudo flatpak install -y flathub com.obsproject.Studio
}
function developerpackage {

sudo $PackageName $PackageInstall \
apache2 php8 php8-mysql apache2-mod_php8 mariadb mariadb-tools mongodb-org nodejs-default npm-default mssql-server php-composer2 \
dotnet-sdk-6.0 llvm-clang gcc gcc-c++ cmake cmake-full extra-cmake-modules rsync gdb ninja \
patterns-devel-base-devel_basis patterns-devel-C-C++-devel_C_C++ \
gtk3-devel \
java-18-openjdk \
patterns-kde-devel_kde_frameworks patterns-kde-devel_qt5 desktop-file-utils #patterns-devel-base-devel_rpm_build 
##Config

    mkdir -p ~/data/db
    a2enmod php8
    sudo echo "AddType application/x-httpd-php .php" >> /etc/apache2/mod_mime-defaults.conf

##Config FINISH
sudo podman
}
sudo $PackageName $UpdateArg
repository
dnfsetup
snapx
flatpak
fonts
asus_pack
basepackage
apples

powershells
ohmyposhs

rpms
runs
bundles
appimages

printers
ide_text
game_video
developerpackage
#
else
echo "Şuan için senin İşletim sisteminle uyumlu değil." && exit 1
fi

