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
    success 1 "Installed Rust."
fi

echo ""
info 0 "Installing cargo crates:"

cargo install -q bat | pipe_output 1
cargo install -q fd-find | pipe_output 1
cargo install -q tokei | pipe_output 1
cargo install -q speedtest-rs | pipe_output 1
cargo install -q cargo-show-asm | pipe_output 1
cargo install -q cargo-expand | pipe_output 1
cargo install -q irust | pipe_output 1
cargo install -q gitui | pipe_output 1
cargo install -q ripgrep | pipe_output 1
cargo install -q exa | pipe_output 1
cargo install -q zellij | pipe_output 1
cargo install -q bottom | pipe_output 1
cargo install -q lsd | pipe_output 1

success 1 "Installed cargo crates."
