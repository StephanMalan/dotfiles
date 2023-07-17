#!/bin/bash
#
# Initial installation of dotfiles

install_gh() {
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if [ -f "/etc/os-release" ]; then
            source /etc/os-release
            case "$ID" in
            ubuntu)
                sudo apt-get install git gh -y -q
                ;;
            arch)
                # TODO
                ;;
            *)
                echo "The '$ID' Linux distro is not yet supported."
                exit 1
                ;;
            esac
        else
            echo "This is a Linux distribution, but /etc/os-release file not found."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "This is macOS."
        # Add macOS-specific commands here
    else
        echo "This script is intended to run on Linux or macOS only."
        exit 1
    fi
}

if ! [ -x "$(command -v gh)" ]; then
    install_gh
fi

gh auth login
gh repo clone StephanMalan/dotfiles ~/projects/dotfiles
