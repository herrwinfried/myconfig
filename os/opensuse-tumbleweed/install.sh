#!/bin/bash

PackageName=zypper --gpg-auto-import-keys
PackageInstall=install -y

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
    echo "$yellow Dikkat ! git Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y git
fi

if ! [ -x "$(command -v screenfetch)" ]; then
  echo "$yellow Dikkat ! screenfetch Paketi Bulunmadığından otomatik yüklenecek." >&2
  sudo zypper --gpg-auto-import-keys in -y screenfetch
fi
################REQUIRED FINISH##################################################################
export distroselect=$(lsb_release -d | awk -F"\t" '{print $2}')


if [ "$distroselect" == "openSUSE Tumbleweed" ]; then
ScriptLocal=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
#
function rpms {

	cd $ScriptLocal/files
	sudo zypper install -y ./*.rpm
	sudo zypper update --refresh -y
}
function runs {
	cd $ScriptLocal/files
	find . -iname '*.run' -exec chmod +x ./"{}" \;
	find . -iname '*.run' -exec sudo ./"{}" \;
}
function bundles {
	cd $ScriptLocal/files
	find . -iname "*.bundle" -exec chmod +x ./"{}" \;
	find . -iname "*.bundle" -exec sudo ./"{}" \;

}
function appimages {

	cd $ScriptLocal/files
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
sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
}
function basepackage {
sudo zypper --gpg-auto-import-keys install -y --from packman ffmpeg gstreamer-plugins-{good,bad,ugly,libav} libavcodec-full vlc-codecs
sudo $PackageName $PackageInstall fetchmsttfonts powerline-fonts \
neofetch screenfetch onboard hwinfo htop ffmpeg redshift zsh git curl wget lsb-release \
telegram-desktop discord brave-browser pinta openshot flameshot gimp \
zsh curl neofetch screenfetch git opi lzip unzip e2fsprogs nano

sudo $PackageName $PackageInstall anydesk
}

function dnfsetup {
sudo zypper --gpg-auto-import-keys install -y dnf rpm-repos-openSUSE
sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
sudo dnf makecache -y && sudo zypper --gpg-auto-import-keys refresh
}
function flatpak {
sudo $PackageName $PackageInstall flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

function printers {
sudo $PackageName $PackageInstall skanlite cups cups-client cups-filters system-config-printer \
skanlite system-config-printer \
hplip
	#sudo adduser $home lpadmin
	sudo service cups start
	sudo systemctl start cups
	sudo systemctl enable cups
}
function ide_text {
	sudo $PackageName $PackageInstall code composer filezilla icedtea-web
}
function game_video {
	sudo $PackageName $PackageInstall lutris minetest steam gamemoded obs-studio kdenlive
	#sudo flatpak install -y flathub com.obsproject.Studio
}
function developerpackage { 
    ##...Apache2, PHP8, MariaDB, MongoDB 
    sudo $PackageName $PackageInstall nodejs-default npm-default python310 python310-pip dotnet-sdk-6.0 mssql-server llvm-clang icu gcc gcc-c++ cmake rsync gdb ninja \
    patterns-devel-base-devel_basis \
    patterns-kde-devel_qt5 patterns-devel-base-devel_rpm_build  patterns-devel-C-C++-devel_C_C++ patterns-kde-devel_kde_frameworks \
    apache2 mariadb php8 php8-mysql apache2-mod_php8 mariadb mariadb-tools mongodb-org \
    gtk3-devel java-18-openjdk
    ##CONFIG
    mkdir -p ~/data/db
    a2enmod php8
    sudo echo "AddType application/x-httpd-php .php" >> /etc/apache2/mod_mime-defaults.conf
    ##CONFIG FINISH   
}
sudo zypper --gpg-auto-import-keys dup -y
repository
dnfsetup
flatpak
basepackage

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
