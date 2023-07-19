#!/bin/bash
#
# Initial installation of dotfiles

display() {
    echo "[\033[00;34mINFO\033[0m] $1"
}

install_gh() {
    display "Installing GitHub Cli"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f "/etc/os-release" ]; then
            source /etc/os-release
            case "$ID" in
            ubuntu)
                sudo apt-get install git gh -y -qq
                ;;
            arch)
                # TODO
                ;;
            *)
                display "The '$ID' Linux distro is not yet supported."
                exit 1
                ;;
            esac
        else
            display "This is a Linux distribution, but /etc/os-release file not found."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        display "This is macOS."
    else
        display "This script is intended to run on Linux or macOS only."
        exit 1
    fi
}

if ! [ -x "$(command -v gh)" ]; then
    install_gh
fi

gh auth login
display "Cloning GitHub repo"
gh repo clone StephanMalan/dotfiles $HOME/projects/dotfiles
source $HOME/projects/dotfiles/install/setup.sh
