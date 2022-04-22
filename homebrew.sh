#!/bin/bash

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# And Install OH-MY-POSH
if [ -f "/usr/local/bin/brew" ]; then
eval "$(/usr/local/bin/brew shellenv)"
brew install oh-my-posh < /dev/null
fi