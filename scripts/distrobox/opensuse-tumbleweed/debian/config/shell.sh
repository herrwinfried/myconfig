#!/bin/bash

shopt -s dotglob
cp -r $ScriptFolder1/data/home/* $USERHOME
SUDO cp -r $ScriptFolder1/data/home/* /root

if [[ -d "$ScriptFolder1/data/root/" ]]; then
    SUDO cp -r $ScriptFolder1/data/root/* /
fi

shopt -u dotglob

if [ -f "/bin/zsh" ]; then
    SUDO usermod -s /bin/zsh "$USERNAME"
fi

if [ -f "/bin/fish" ] && [ ! -x "$(command -v fisher)" ]; then
    fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source ; fisher install jorgebucaran/fisher"
fi
