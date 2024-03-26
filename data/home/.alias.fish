if test (uname -s) != "Linux"
    echo (set_color red)"For Linux only, are you sure you added the correct alias file?"(set_color normal)
    exit 1
end

if test -z $LC_ALL; and test -z $LANG
    set -x LANG C.utf8
    set -x LC_ALL $LANG
end

set OhMyPoshTheme ~/.poshthemes/default.omp.json

set -x PATH $PATH $HOME/bin $HOME/development $HOME/.local/bin

if test -f "/home/linuxbrew/.linuxbrew/bin/brew"
     /home/linuxbrew/.linuxbrew/bin/brew shellenv | source
end

if test -f $HOME/bin/docker; or test -f /usr/bin/docker
    set -x DOCKER_HOST unix:///run/user/1000/docker.sock
end

function Base_Font
    set termcols (tput cols)
    set bold (tput bold)
    set fontnormal (tput init)
    set fontreset (tput reset)
    set underline (tput smul)
    set standout (tput smso)
    set normal (tput sgr0)
    set black (tput setaf 0)
    set red (tput setaf 1)
    set green (tput setaf 2)
    set yellow (tput setaf 3)
    set blue (tput setaf 4)
    set magenta (tput setaf 5)
    set cyan (tput setaf 6)
    set white (tput setaf 7)
end

if test -x oh-my-posh; and test -f $OhMyPoshTheme;
    if test "$TERM" != "linux"
        oh-my-posh init fish | source
    end

    function OhMyPoshThemeUpdate
        set themeFile $HOME/.poshthemes/default.omp.json
        wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.poshthemes/default.omp.json" -O $themeFile
    end
end

function englishRun
    if test (count $argv) -eq 0
        echo "Usage: $argv[0] <command>"
        exit 1
    else
        set -x LC_ALL C.utf8
        set -x LANG $LC_ALL
        $argv
    end
end

function aliasUpdate
    rm -r ~/.alias
    wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias" -O ~/.alias
    rm -r ~/.alias.ps1
    wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.ps1" -O ~/.alias.ps1
    rm -r ~/.alias.fish
    wget "https://raw.githubusercontent.com/herrwinfried/myconfig/linux/data/home/.alias.fish" -O ~/.alias.fish
end

function checkwsl
    set unameout (uname -r | tr '[:upper:]' '[:lower:]')
    if test "$unameout" = "*microsoft*" -o "$unameout" = "*wsl*" -o -f /proc/sys/fs/binfmt_misc/WSLInterop -o $WSL_DISTRO_NAME -o (echo (cat /proc/cpuinfo | grep -m1 microcode | cut -f2 -d:)) = "0xffffffff" -a $WSL_DISTRO_NAME
        return 0
    else
        return 1
    end
end

if test -d "/windir/c"; or test -d "/mnt/c"; and checkwsl
    function wsl_c
        if test -d "/windir/c"
            cd /windir/c
        elif test -d "/mnt/c"
            cd /mnt/c
        end
    end
end
