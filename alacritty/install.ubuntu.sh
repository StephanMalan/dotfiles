#!/bin/bash
#
# Install Alacritty for Ubuntu

source "$DOTFILES/install/utils.sh"

info 0 "Installing Alacritty:"
sudo apt-get install alacritty -y -q | pipe_output 1
success 1 "Installed Alacritty."
