#!/bin/bash

### Root
#cd $ScriptFolder/data/home; cp -r * /root/; cp -r .* /root/
sudo mkdir -p /root/.config
sudo mkdir -p /root/.config/powershell
sudo cp -r $ScriptFolder/data/home/.alias* /root/
sudo cp -r $ScriptFolder/data/home/.config/* /root/.config

sudo ln -sf $HomePWD/.poshthemes /root/.poshthemes

sudo cp $ScriptFolder/data/home/.bashrc /root/.bashrc

sudo cp $ScriptFolder/data/home/.zshrc /root/.zshrc

###USER

mkdir -p $HomePWD/.config
mkdir -p $HomePWD/.config/powershell
cp -r $ScriptFolder/data/home/.alias* $HomePWD
cp -r $ScriptFolder/data/home/.config/* $HomePWD/.config
mkdir -p $HomePWD/.poshthemes
cp -r $ScriptFolder/data/default.omp.json $HomePWD/.poshthemes

mkdir -p $HomePWD/source

ln -s /opt/lampp/htdocs $HomePWD/lamppHtdocs

cp $ScriptFolder/data/home/.bashrc $HomePWD/.bashrc

cp $ScriptFolder/data/home/.zshrc $HomePWD/.zshrc

if [ -f "/bin/zsh" ]; then
    sudo usermod -s /bin/zsh $Username
fi

if [ -f "/bin/fish" ]; then

    if [ ! -x "$(command -v fisher)" ]; then

        fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source ; fisher install jorgebucaran/fisher"

    fi

    if [ -x "$(command -v fisher)" ]; then

        fish -c "fisher install dracula/fish"
        fish -c 'fish_config theme choose "Dracula Official"'

    fi

fi
