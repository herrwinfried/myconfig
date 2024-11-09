#!/bin/bash

function ZSH_PLUGIN_DOWNLOAD() {
    mkdir -p ~/.zsh
    mkdir -p ~/.zsh/plugins
    SUDO mkdir -p /root/.zsh
    SUDO mkdir -p /root/.zsh/plugins
    git clone $1 ~/.zsh/plugins/$2
    sudo cp -r ~/.zsh/plugins/$2 /root/.zsh/plugins/$2
}

ZSH_PLUGIN_DOWNLOAD https://github.com/zsh-users/zsh-autosuggestions zsh-autosuggestions
ZSH_PLUGIN_DOWNLOAD https://github.com/marlonrichert/zsh-autocomplete zsh-autocomplete
ZSH_PLUGIN_DOWNLOAD https://github.com/zsh-users/zsh-completions zsh-completions
ZSH_PLUGIN_DOWNLOAD https://github.com/zsh-users/zsh-syntax-highlighting zsh-syntax-highlighting
