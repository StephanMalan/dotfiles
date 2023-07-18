#!/bin/bash
#
# Custom aliases

# ZSH
alias aa="nano $DOTFILES/zsh/aliases.sh && exec zsh"
alias af="nano $DOTFILES/zsh/functions.sh && exec zsh"

# Python
alias act="source .venv/bin/activate"
alias python="python3"

# Rust
alias cw="cargo watch -x 'run'"

# Misc
alias ll="lsd -al"
alias vim="nvim"
