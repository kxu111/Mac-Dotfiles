# syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33

# fzf
source <(fzf --zsh)
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/config"
export FZF_COMPLETION_TRIGGER="ff"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

# vi mode
KEYTIMEOUT=1
bindkey -v

