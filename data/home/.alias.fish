if test (uname -s) != "Linux"
    echo (tput setaf 1)"For Linux only, are you sure you added the correct alias file?"(tput setaf 7)
    exit 1
end

set -U fish_greeting
set OhMyPoshTheme ~/.poshthemes/default.omp.json

if test -d $HOME/bin
    set -x PATH $PATH $HOME/bin
end

if test -d $HOME/development
    set -x PATH $PATH $HOME/development
end

if test -d $HOME/.local/bin
    set -x PATH $PATH $HOME/.local/bin
end

if test -f $HOME/bin/docker
    set -x DOCKER_HOST unix:///run/user/1000/docker.sock
end

if test -f /usr/local/bin/fish_command_not_found
    source /usr/local/bin/fish_command_not_found
end


function checkwsl
    set -l unameout (uname -r | tr '[:upper:]' '[:lower:]')
    if string match -q -r "microsoft" $unameout; and \
        string match -q -r "wsl" $unameout; and \
        test -f /proc/sys/fs/binfmt_misc/WSLInterop; and \
        test -n "$WSL_DISTRO_NAME"; and \
        string match -q -r "0xffffffff" (cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d: )
        return 0 > /dev/null
    else
        return 1
    end
end


if test -f /home/linuxbrew/.linuxbrew/bin/brew
    /home/linuxbrew/.linuxbrew/bin/brew shellenv | source

    function brewInstall
        brew install $argv < /dev/null
    end

    function brewInstallCask
        brew install --cask $argv < /dev/null
    end
end

if test "$TERM" != "linux"
    if test -x (command -v oh-my-posh) && test -f $OhMyPoshTheme;
     oh-my-posh init fish --config $OhMyPoshTheme | source
    end
end

if checkwsl
    if test -x ancs4linux-ctl
        function ios_pair
            set iosAddress (ancs4linux-ctl get-all-hci | jq -r '.[0]')
            echo "Connect to " (hostname) " from your phone."
            ancs4linux-ctl enable-advertising --hci-address $iosAddress --name (hostname)
        end
    end
end

function rootMode
    if test (count $argv) -ne 0
        set XDG_DE (echo $XDG_CURRENT_DESKTOP | tr '[:upper:]' '[:lower:]')
        if test $XDG_DE = "kde"
            sudo pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY KDE_SESSION_VERSION=5 KDE_FULL_SESSION=true $argv
        else
            sudo pkexec env DISPLAY=$DISPLAY XAUTHORITY=$XAUTHORITY $argv
        end
    else
        echo "$red""You didn't write anything to run.""$white"
    end
end

function englishRun
    if test (count $argv) -ne 0
        set -x LC_ALL C
        set -x LANG $LC_ALL
        eval $argv
    else
        echo "$red""You didn't write anything to run.""$white"
    end
end

function aliasUpdate
    rm -r ~/.alias
    wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias -O ~/.alias
    rm -r ~/.alias.ps1
    wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.ps1 -O ~/.alias.ps1
    rm -r ~/.alias.fish
    wget https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.fish -O ~/.alias.fish
end

if test -x (command -v oh-my-posh); and test -f "$OhMyPoshTheme"
    function OhMyPoshThemeUpdate
        set themeFile "$HOME/.poshthemes/default.omp.json"
        wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/default.omp.json" -O "$themeFile"
    end
end