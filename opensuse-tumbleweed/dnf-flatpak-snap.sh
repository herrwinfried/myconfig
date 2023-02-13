#!/bin/bash
function dnfsetup {
sudo zypper --gpg-auto-import-keys install -y dnf libdnf-repo-config-zypp
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

dnfsetup
flatpakSetup
snapSetup
