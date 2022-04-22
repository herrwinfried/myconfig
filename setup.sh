#!/bin/bash

defaults write com.apple.Finder AppleShowAllFiles true

xcode-select --install
xcodebuild -license

function brewInstall {
    brew install $1 < /dev/null
}

function brewInstallCask {
    brew install --cask $1 < /dev/null
}

if [ -f "/usr/local/bin/brew" ]; then
eval "$(/usr/local/bin/brew shellenv)"

brewInstall oh-my-posh 
brewInstall git 
brewInstallCask powershell 
#brewInstallCask dotnet 
brewInstall gnupg 
brewInstall wget 
brewInstall mas 
else

echo "Brew yüklü mü? İşlem iptal edildi..."
exit 1
fi

if [ ! -f "/Applications/Visual Studio Code.app" ]; then
wget "https://code.visualstudio.com/sha/download?build=stable&os=darwin" -O VSCode-darwin.zip
unzip VSCode-darwin.zip -d /Applications
fi

if [ ! -f "/Applications/iTerm.app" ]; then
wget "https://iterm2.com/downloads/stable/iTerm2-3_4_19.zip" -O iterm2.zip
unzip iterm2.zip -d /Applications
fi

#xcode
mas install 497799835

function fonts {
if [ -f "/Library/Fonts/MesloLGS NF Bold Italic.ttf" ]; then
sudo rm -rf /Library/Fonts/MesloLGS NF Bold Italic.ttf
fi

if [ -f "/Library/Fonts/MesloLGS NF Bold.ttf" ]; then
sudo rm -rf /Library/Fonts/MesloLGS NF Bold.ttf
fi

if [ -f "/Library/Fonts/MesloLGS NF Italic.ttf" ]; then
sudo rm -rf /Library/Fonts/MesloLGS NF Italic.ttf
fi

if [ -f "/Library/Fonts/MesloLGS NF Regular.ttf" ]; then
sudo rm -rf /Library/Fonts/MesloLGS NF Regular.ttf
fi
##### WGET
if [ ! -f "/Library/Fonts/MesloLGS NF Bold Italic.ttf" ]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf -P /Library/Fonts
fi

if [ ! -f "/Library/Fonts/MesloLGS NF Bold.ttf" ]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf -P /Library/Fonts
fi

if [ ! -f "/Library/Fonts/MesloLGS NF Italic.ttf" ]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf -P /Library/Fonts
fi

if [ ! -f "/Library/Fonts/MesloLGS NF Regular.ttf" ]; then
sudo wget https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf -P /Library/Fonts
fi
}