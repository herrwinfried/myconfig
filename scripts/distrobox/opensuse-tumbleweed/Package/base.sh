Package_a="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Package_a+=" bash zsh bash-completion fish lsb-release e2fsprogs nano"
Package_a+=" lzip unrar unzip java-20-openjdk openssh-server xdg-user-dirs"
Package_a+=" cnf-rs cnf-rs-bash cnf-rs-zsh powerline-fonts"

Package_b="breeze"
SUDO $Package $PackageInstall which shadow hostname
SUDO $Package $PackageInstall --no-recommends $Package_a

SUDO $Package $PackageInstall --no-recommends $Package_b
