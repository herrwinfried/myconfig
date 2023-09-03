#!/bin/bash
sudo $Package $PackageInstall gcc
OldPw=$(pwd)
cd /home
sudo mkdir -p /home/linuxbrew/
sudo ln -s /home/homebrew/ /home/linuxbrew/.linuxbrew
sudo git clone https://github.com/Homebrew/brew /home/homebrew
sudo chown -R $Username /home/homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"


brew update --force --quiet

chmod -R go-w "$(brew --prefix)/share/zsh"

cd $OldPw
unset OldPw

if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

function brewInstall {
    /home/linuxbrew/.linuxbrew/bin/brew install $1 </dev/null
}

function brewInstallCask {
    /home/linuxbrew/.linuxbrew/bin/brew install --cask $1 </dev/null
}


if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    brewInstall oh-my-posh
fi
