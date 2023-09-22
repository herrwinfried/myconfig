Package_a="hwinfo screenfetch neofetch htop git git-lfs curl wget"
Package_a+=" bash zsh bash-completion fish redhat-lsb-core e2fsprogs nano"
Package_a+=" lzip unrar unzip java-latest-openjdk openssh-server cracklib-dicts xdg-user-dirs"

Package_b="plasma-breeze"

SUDO $Package $PackageInstall $Package_a

SUDO $Package $PackageInstall $Package_b
