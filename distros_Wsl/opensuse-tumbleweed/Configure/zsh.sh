#!/usr/bin/env bash

set -euo pipefail

PLUGIN_DIR="${HOME}/.zsh/plugins"

mkdir -p "$PLUGIN_DIR"

plugins=(
    "https://github.com/zsh-users/zsh-autosuggestions"
    "https://github.com/marlonrichert/zsh-autocomplete"
    "https://github.com/zsh-users/zsh-completions"
    "https://github.com/zsh-users/zsh-syntax-highlighting"
)

for repo in "${plugins[@]}"; do
    name="${repo##*/}"
    target="${PLUGIN_DIR}/${name}"

    if [[ -d "$target/.git" ]]; then
        echo "Updating $name"
        git -C "$target" pull --ff-only
    else
        echo "Installing $name"
        git clone --depth=1 "$repo" "$target"
    fi
done