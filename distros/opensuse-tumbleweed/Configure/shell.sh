#!/usr/bin/env bash
# Configure/shell.sh — Set the default shell to zsh
set -euo pipefail

if [[ -f "/bin/zsh" ]]; then
	sudo usermod -s /bin/zsh "$USER"
fi