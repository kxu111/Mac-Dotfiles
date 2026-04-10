if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias nrs='sudo darwin-rebuild switch --flake ~/nix'
alias neofetch='fastfetch'
alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'
alias m='mkdir -p'
alias vi='nvim'
alias tn='tmux new-session -s'
alias ta='tmux attach -t'
alias tls='tmux ls'
alias tkill='tmux kill-session -t'
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export MANPAGER='nvim +Man!'
export TEALDEER_CONFIG_DIR=~/.config/tealdeer
export PATH="$HOME/.cargo/bin:$PATH"

# Syntax highlighting
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33

source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

