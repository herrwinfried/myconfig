test -s ~/.alias && . ~/.alias || true

if command -v warp-cli &>/dev/null; then
    warp-cli generate-completions bash > ~/.local/share/bash-completion/warp-cli
fi

    mkdir -p ~/.local/share/bash-completion
if [ -d "$HOME/.local/share/bash-completion" ]; then
    for file in "$HOME/.local/share/bash-completion"/*; do
        [ -f "$file" ] && source "$file"
    done
fi


if [ -f /etc/profile.d/bash_completion.sh ]; then
    . /etc/profile.d/bash_completion.sh
fi
