test -s ~/.alias && . ~/.alias || true

if command -v warp-cli &>/dev/null; then
    mkdir -p ~/.zsh/completions
    warp-cli generate-completions zsh >~/.zsh/completions/_warp-cli
fi

fpath+=~/.zsh/completions
autoload -Uz compinit && compinit
