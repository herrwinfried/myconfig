#!/bin/bash
PackageName="dnf"
PackageInstall="install -y --skip-broken"
UpdateArg="update -y"


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
    echo "$yellow Dikkat ! redhat-lsb-core Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install -y redhat-lsb-core
fi

if ! [ -x "$(command -v git)" ]; then
    echo "$yellow Dikkat ! git Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install -y git
fi

if ! [ -x "$(command -v wget)" ]; then
    echo "$yellow Dikkat ! wget Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo dnf install -y wget
fi
################################

################REQUIRED FINISH##################################################################
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')


if [ "$distroselect" == "Fedora release 37 (Thirty Seven)" ]; then
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#

function checkFolder {
mkdir -p $ScriptLocal/$FolderName/$FolderScript
cd $ScriptLocal/$FolderName/$FolderScript
}
function rpms {

	checkFolder
	sudo $PackageName $PackageInstall ./*.rpm
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
sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
#######################################################################################################
sudo dnf install -y --skip-broken dnf-plugins-core
sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/x86_64/
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
#######################################################################################################

cat > mongodb.repo << "EOF"
[Mongodb]
name=MongoDB Repository
baseurl=https://repo.mongodb.org/yum/redhat/8/mongodb-org/4.4/x86_64/
gpgcheck=1
enabled=1
gpgkey=https://www.mongodb.org/static/pgp/server-4.4.asc
EOF
#######################################################################################################
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
#######################################################################################################
cat > /etc/yum.repos.d/AnyDesk-Fedora.repo << "EOF" 
[anydesk]
name=AnyDesk Fedora - stable
baseurl=http://rpm.anydesk.com/fedora/$basearch/
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://keys.anydesk.com/repos/RPM-GPG-KEY
EOF
#######################################################################################################
sudo dnf copr enable -y lukenukem/asus-linux
#######################################################################################################
}

function kde_function {
sudo $PackageName $UpdateArg
## Music
    sudo flatpak install -y flathub org.kde.vvave
### Ses kayıt edici, Video oynatıcı, Metin düzenleyici , Dosya yöneticisi , KDIFF, Takvim, kdeconnect, To do, dosya bulucu, kamera, kde IDE
    sudo $PackageName $PackageInstall krecorder dragon kwrite krename kdiff3 kalendar kde-connect kate kfind kleopatra kamoso kdevelop kdevelop-php kdevelop-pg-qt-devel kio-gdrive
## YT Music QT
    sudo flatpak install -y flathub org.kde.audiotube
}

function fonts {
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /usr/share/fonts/truetype
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /usr/share/fonts/truetype
fc-cache
}

function basepackage {
sudo rpm -i https://downloads.sourceforge.net/project/mscorefonts2/rpms/msttcore-fonts-installer-2.6-1.noarch.rpm

sudo dnf install -y powerline-fonts \
neofetch screenfetch onboard hwinfo htop ffmpeg redshift zsh git curl wget redhat-lsb-core \
discord brave-browser pinta flameshot gimp \
zsh curl git lzip unzip nano e2fsprogs thunderbird



sudo dnf installstall -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs
#openshot
    sudo flatpak install -y flathub org.telegram.desktop
    sudo flatpak install -y flathub io.github.mimbrero.WhatsAppDesktop
    sudo snap install authy
    sudo snap install termius-app
    sudo flatpak install -y flathub org.onlyoffice.desktopeditors

kde_function
sudo $PackageName $PackageInstall anydesk

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
sudo $PackageName $PackageInstall curl tar libicu openssl-libs
sudo $PackageName $PackageInstall jq
pwshcore=$(curl -s https://api.github.com/repos/PowerShell/PowerShell/releases/latest| jq -r ".assets[] | select(.name | test(\"linux-x64.tar.gz\")) | .browser_download_url")

curl -L $pwshcore -o /tmp/powershell.tar.gz
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
    sudo $PackageName $PackageInstall libimobiledevice-utils libimobiledevice-devel usbmuxd
}
function asus_pack {
sudo $PackageName $PackageInstall asusctl asusctl-rog-gui
sudo systemctl enable supergfxd.service
sudo systemctl enable asusd.service
sudo systemctl start supergfxd.service
sudo systemctl start asusd.service
}
function flatpakx {
sudo $PackageName $PackageInstall flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}
function snapx {
  sudo $PackageName $PackageInstall snapd
  sudo systemctl enable --now snapd
  sudo systemctl start --now snapd
}
function printers {
sudo $PackageName $PackageInstall skanlite cups cups-client cups-filters system-config-printer hplip
	#sudo adduser $home lpadmin
	sudo service cups start
	sudo systemctl start cups
	sudo systemctl enable cups
}
function ide_text {
	sudo $PackageName $PackageInstall code filezilla
}
function game_video {
	sudo $PackageName $PackageInstall lutris minetest steam gamemode obs-studio kdenlive
	sudo flatpak install -y flathub com.usebottles.bottles
	#sudo sudo flatpak install -y flathub com.obsproject.Studio
}
function developerpackage {

sudo $PackageName $PackageInstall \
httpd mariadb-server mariadb mongodb-org nodejs npm composer \
php php-mysqlnd dotnet-sdk-6.0 gcc gcc-c++ cmake cmake-full extra-cmake-modules rsync gdb ninja-build \
gtk3-devel java-latest-openjdk 
kf5-rpm-macros.noarch qt5-rpm-macros.noarch @development-tools @c-development
##Config
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

    mkdir -p /home/winfried/data/db
    a2enmod php8
    sudo echo "AddType application/x-httpd-php .php" >> /etc/apache2/mod_mime-defaults.conf

##Config FINISH
sudo $PackageName $PackageInstall podman
sudo flatpak install -y flathub io.podman_desktop.PodmanDesktop

}
sudo $PackageName $UpdateArg
repository
snapx
flatpakx
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

