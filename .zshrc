if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

alias neofetch='fastfetch'
alias nrs='sudo darwin-rebuild switch --flake ~/nix'
alias vi='nvim'
alias vizsh='nvim ~/.zshrc; source ~/.zshrc'
alias m='mkdir -p'
alias cat='bat'
alias y='yazi'
alias news='newsboat'
alias lg='lazygit'
alias cron-sync="crontab ~/dotfiles/crontab"

alias ls='eza --icons --group-directories-first'
alias l='eza -l'
alias ll='eza -l'
alias la='eza -a'
alias lla='eza -la'
alias llh='eza -lh'
alias llah='eza -lah'

# tmux aliases
alias tls='tmux ls'
ta() {
    # If no tmux sessions exist, create one
    if ! tmux has-session 2>/dev/null; then
        tmux new-session -d -s "$(whoami)"
    fi
    # If argument provided, attach to that session
    if [ -n "$1" ]; then
        tmux attach -t "$1"
    else
        tmux attach
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

export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export EDITOR=nvim
export MANPAGER='nvim +Man!'
export TEALDEER_CONFIG_DIR=~/.config/tealdeer
export PATH="$HOME/.cargo/bin:$PATH"
export BAT_THEME=vague

source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} ma=0\;33

source <(fzf --zsh)
export FZF_DEFAULT_OPTS_FILE="$HOME/.config/fzf/config"
export FZF_COMPLETION_TRIGGER="ff"

eval "$(zoxide init --cmd cd zsh)"

KEYTIMEOUT=1
bindkey -v

source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

