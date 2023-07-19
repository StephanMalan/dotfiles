#!/bin/bash
#
# Install main dependencies for Ubuntu

set -e

source "$DOTFILES/install/utils.sh"

info 0 "Update system:"
sudo apt-get update -y -q | pipe_output 1
sudo apt-get full-upgrade -y -q | pipe_output 1
success 1 "Updated system."

echo ""

info 0 "Install main dependencies:"
sudo apt-get autoremove -y -q | pipe_output 1
sudo apt-get install \
    build-essential \
    libssl-dev \
    net-tools \
    curl \
    docker.io \
    ffmpeg \
    git \
    gh \
    golang \
    lf \
    pkg-config \
    tree \
    zsh \
    -y -q | pipe_output 1
sudo snap install docker | pipe_output 1
sudo snap install dbeaver-ce | pipe_output 1
sudo snap install discord | pipe_output 1
sudo snap install postman | pipe_output 1
sudo snap install intellij-idea-ultimate --classic --edge
sudo setfacl --modify user:${USER}:rw /var/run/docker.sock
sudo snap install --classic code | pipe_output 1
sudo snap install --edge nvim --classic | pipe_output 1
success 1 "Installed main dependencies."
