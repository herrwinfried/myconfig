#!/bin/bash

function cpp {
package="patterns-devel-base-devel_basis patterns-devel-C-C++-devel_C_C++ gdb ninja llvm-clang gcc gcc-c++ cmake cmake-full extra-cmake-modules"
sudo $PackageName $PackageInstall $package
}

function csharp {
package="dotnet-sdk-7.0"
sudo $PackageName $PackageInstall $package
}

function php {
package="apache2 php8 php8-mysql apache2-mod_php8 mariadb mariadb-tools php-composer2 phpMyAdmin phpMyAdmin-apache"
sudo $PackageName $PackageInstall $package
a2enmod php8
sudo echo "AddType application/x-httpd-php .php" >> /etc/apache2/mod_mime-defaults.conf
}

function rpm {
package="desktop-file-utils patterns-devel-base-devel_rpm_build"
sudo $PackageName $PackageInstall $package
}

function kde_qt {
package="desktop-file-utils patterns-kde-devel_kde_frameworks patterns-kde-devel_qt6"
sudo $PackageName $PackageInstall $package
}

function other {
package1="rsync gtk3-devel java-19-openjdk nodejs-default npm-default" #mongodb-org 
sudo $PackageName $PackageInstall $package1
}
function docker {
package="docker docker-compose docker-compose-switch yast2-docker"
sudo $PackageName $PackageInstall $package
sudo usermod -G docker -a $home
######### ROOTLESS ##############################
su -l $home -c "curl -fsSL https://get.docker.com/rootless | sh"
su -l $home -c "touch ~/Masaüstü/docker-user-socket.sh"
echo "
#!/bin/bash
systemctl --user enable --now docker.service
systemctl --user enable --now docker.socket

echo "export DOCKER_HOST=unix:///run/user/1000/docker.sock" >> $HomePWD/.alias
echo "export PATH=/home/$home/bin:\$PATH" >> $HomePWD/.alias

" > $HomePWD/Masaüstü/docker-user-socket.sh 
chmod +x $HomePWD/Masaüstü/docker-user-socket.sh
}

function podman {
package="podman"
packageFlatpak="io.podman_desktop.PodmanDesktop"
sudo $PackageName $PackageInstall $package
sudo $FlatpakInstall $packageFlatpak
#sudo systemctl enable --now podman.service podman.socket
######### ROOTLESS ##############################
su -l $home -c "touch ~/Masaüstü/podman-user-socket.sh"
echo "
#!/bin/bash
systemctl --user enable --now podman.service podman.socket
" > $HomePWD/Masaüstü/podman-user-socket.sh 
chmod +x $HomePWD/Masaüstü/podman-user-socket.sh
#systemctl --user enable --now podman.service podman.socket
}
function distrobox {
package="distrobox"  
sudo $PackageName $PackageInstall $package
}



if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
# NOT WSL

docker
podman
distrobox
cpp
csharp 
#php
rpm
kde_qt
other

elif [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
# WSL

cpp
csharp
#php
rpm
kde_qt
other

fi