#!/bin/bash
#
# Cargo install/update crates

source "$DOTFILES/install/utils.sh"

set -e

info 0 "Installing/Updating cargo crates:"

info 1 "'cargo-quickinstall' crate"
cargo install cargo-quickinstall -q

cat "$DOTFILES/rust/cargo.list" | while IFS= read -r line; do
    info 1 "'$line' crate"
    cargo quickinstall $line
done

success 1 "Installed/Updated cargo crates."
