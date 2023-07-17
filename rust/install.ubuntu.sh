#!/bin/bash
#
# Install rust and cargo crates for Ubuntu

source "$DOTFILES/install/utils.sh"

info 0 "Installing Rust:"
if which rustc >/dev/null 2>&1; then
    warn 1 "Rust already installed, updating:"
    rustup update | pipe_output 2
else
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source "$HOME/.cargo/env"
    success 1 "Installed Rust."
fi

source "$DOTFILES/rust/cargo-install.sh"
