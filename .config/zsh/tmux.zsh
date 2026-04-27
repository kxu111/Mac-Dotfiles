alias tls='tmux ls'

ta() {
  if ! tmux has-session 2>/dev/null; then
    tmux new-session -d -s "$(whoami)"
  fi
  [[ -n "$1" ]] && tmux attach -t "$1" || tmux attach
}

tkill() {
  [[ -n "$1" ]] && tmux kill-session -t "$1" || tmux kill-session
}

_tmux_completion() {
  local -a sessions
  sessions=($(tmux list-sessions -F "#{session_name}" 2>/dev/null))
  compadd -a sessions
}
compdef _tmux_completion ta
compdef _tmux_completion tkill
