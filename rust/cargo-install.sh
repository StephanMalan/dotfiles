#!/bin/bash
#
# Cargo install/update crates

source "$DOTFILES/install/utils.sh"

set -e

cargo_install() {
    info 0 "Installing/Updating '$1' crate"
    cargo install -q $1
    success 1 "Installed/Updated '$1'"
}

info 0 "Installing/Updating cargo crates:"

cat "$DOTFILES/rust/cargo.list" | while IFS= read -r line; do
    info 1 "Installing/Updating '$line' crate"
    cargo install -q $line
done

success 1 "Installed/Updated cargo crates."
