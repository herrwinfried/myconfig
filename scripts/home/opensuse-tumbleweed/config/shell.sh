#!/bin/bash

### Root

SUDO mkdir -p /root/.config
SUDO mkdir -p /root/.config/powershell
SUDO mkdir -p /root/.config/MangoHud

SUDO cp -r $ScriptFolder1/dotfiles/home/.alias* /root/
SUDO cp -r $ScriptFolder1/dotfiles/home/.config/* /root/.config

SUDO ln -sf $HomePWD/.poshthemes /root/.poshthemes

SUDO cp $ScriptFolder1/dotfiles/home/.bashrc /root/.bashrc

SUDO cp $ScriptFolder1/dotfiles/home/.zshrc /root/.zshrc

###USER

mkdir -p $HomePWD/.config
mkdir -p $HomePWD/.config/powershell
mkdir -p $HomePWD/.config/MangoHud

cp -r $ScriptFolder1/dotfiles/home/.alias* $HomePWD
cp -r $ScriptFolder1/dotfiles/home/.config/* $HomePWD/.config
mkdir -p $HomePWD/.poshthemes
cp -r $ScriptFolder1/dotfiles/default.omp.json $HomePWD/.poshthemes

mkdir -p $HomePWD/source

cp $ScriptFolder1/dotfiles/home/.bashrc $HomePWD/.bashrc

cp $ScriptFolder1/dotfiles/home/.zshrc $HomePWD/.zshrc

if [ -f "/bin/zsh" ]; then
    SUDO usermod -s /bin/zsh $Username
fi

if [ -f "/bin/fish" ]; then

    if [ ! -x "$(command -v fisher)" ]; then

        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source ; fisher install jorgebucaran/fisher"

    fi

fi
