#!/bin/bash
    SUDO $Package $PackageInstall gcc
    old_pw=$(pwd)

    SUDO mkdir -p /home/linuxbrew/.linuxbrew
    SUDO chown -R $USERNAME /home/linuxbrew/.linuxbrew
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    cd $old_pw
    unset old_pw

    if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
brew_install() {
    if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        /home/linuxbrew/.linuxbrew/bin/brew install $1 </dev/null
    fi
}
brew_install_cask() {
    if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        /home/linuxbrew/.linuxbrew/bin/brew install --cask $1 </dev/null
    fi
}

brew_install oh-my-posh