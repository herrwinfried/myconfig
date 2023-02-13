#!/bin/bash

function podman {
package1="podman"
packageFlatpak="io.podman_desktop.PodmanDesktop"
sudo $PackageName $PackageInstall $package1
sudo $FlatpakInstall $packageFlatpak
sudo systemctl enable --now podman.service podman.socket
#systemctl --user enable --now podman.service podman.socket
}
function cpp {
package1="patterns-devel-base-devel_basis patterns-devel-C-C++-devel_C_C++ gdb ninja llvm-clang gcc gcc-c++ cmake cmake-full extra-cmake-modules"
sudo $PackageName $PackageInstall $package1
}
function csharp {
package1="dotnet-sdk-7.0 dotnet-sdk-6.0"
sudo $PackageName $PackageInstall $package1	
}
function other {
package1="mongodb rsync gtk3-devel java-18-openjdk"
sudo $PackageName $PackageInstall $package1
mkdir -p ~/data/db
}
function php {
package1="apache2 php8 php8-mysql apache2-mod_php8 mariadb mariadb-tools mongodb-org nodejs-default npm-default php-composer2 phpMyAdmin phpMyAdmin-apache"
sudo $PackageName $PackageInstall $package1	

a2enmod php8
sudo echo "AddType application/x-httpd-php .php" >> /etc/apache2/mod_mime-defaults.conf

}
function rpmpackage {
package1="desktop-file-utils patterns-devel-base-devel_rpm_build"
sudo $PackageName $PackageInstall $package1	
}
function qtkde {
package1="desktop-file-utils patterns-kde-devel_kde_frameworks patterns-kde-devel_qt5"
sudo $PackageName $PackageInstall $package1	
}


if [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" == "0xffffffff" ]; then
#wsl

cpp
other
php
csharp

elif [ "$(echo $(cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:))" != "0xffffffff" ]; then
#NORMAL

cpp
other
podman
php
csharp
#qtkde
#rpmpackage

fi