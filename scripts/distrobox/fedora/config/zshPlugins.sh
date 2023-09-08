#!/bin/bash

mkdir -p ~/.zsh
mkdir -p ~/.zsh/plugins

git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/plugins/zsh-autosuggestions
git clone https://github.com/marlonrichert/zsh-autocomplete.git ~/.zsh/plugins/zsh-autocomplete
git clone https://github.com/zsh-users/zsh-completions.git ~/.zsh/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh/plugins/zsh-syntax-highlighting


$SUDO mkdir -p /root/.zsh
$SUDO mkdir -p /root/.zsh/plugins

$SUDO git clone https://github.com/zsh-users/zsh-autosuggestions /root/.zsh/plugins/zsh-autosuggestions
$SUDO git clone https://github.com/marlonrichert/zsh-autocomplete.git /root/.zsh/plugins/zsh-autocomplete
$SUDO git clone https://github.com/zsh-users/zsh-completions.git /root/.zsh/plugins/zsh-completions
$SUDO git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /root/.zsh/plugins/zsh-syntax-highlighting