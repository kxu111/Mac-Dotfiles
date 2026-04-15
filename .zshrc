if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias nrs='sudo darwin-rebuild switch --flake ~/nix'
alias neofetch='fastfetch'
alias y='yazi'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias m='mkdir -p'
alias vi='nvim'

# tmux aliases
alias tn='tmux new-session -s'
alias tls='tmux ls'
ta() {
    if [ -n "$1" ]; then
        tmux attach-session -t "$1"
    else
        tmux attach-session
    fi
}
tkill() {
    if [ -n "$1" ]; then
        tmux kill-session -t "$1"
    else
        tmux kill-session
    fi
}

_tmux_completion() {
    local -a sessions
    sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
    compadd -a sessions
}
compdef _tmux_completion ta
compdef _tmux_completion tkill

export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export TEALDEER_CONFIG_DIR=~/.config/tealdeer
export PATH="$HOME/.cargo/bin:$PATH"

# Syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33

# fzf (C-r to trigger)
eval "$(fzf --zsh)"

# zoxide
eval "$(zoxide init --cmd cd zsh)"

source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

