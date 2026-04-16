#!/bin/bash

# attempts to attach to tmux. if there is no session, create one
tmux attach || tmux new-session -s "$(whoami)"
