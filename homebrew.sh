#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# And Install OH-MY-POSH
if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew install oh-my-posh
fi