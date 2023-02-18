#!/bin/bash
function dnfsetup {
sudo zypper --gpg-auto-import-keys install -y dnf libdnf-repo-config-zypp
sudo dnf swap -y PackageKit-backend-zypp PackageKit-backend-dnf
sudo dnf makecache -y && sudo zypper --gpg-auto-import-keys refresh

echo "protect_running_kernel=False" >> /etc/dnf/dnf.conf

}
function flatpakSetup {
sudo $PackageName $PackageInstall flatpak
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
}

function snapSetup {
  sudo $PackageName $PackageInstall snapd
  sudo systemctl enable --now snapd
  sudo systemctl enable --now snapd.apparmor
}

dnfsetup
flatpakSetup
snapSetup