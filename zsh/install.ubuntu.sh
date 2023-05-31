#!/bin/bash
#
# Install omz and plugins for Ubuntu

source "$DOTFILES/install/utils.sh"

info 0 "Installing Oh-my-zsh:"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -s
    success 1 "Installed Oh-my-zsh."
else
    warn 1 "Oh my zsh already installed."
fi

echo ""
info 0 "Installing Oh-my-zsh plugins:"

info 1 "Installing Zsh-autosuggestions plugin:"
autosuggest_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
if [ ! -d "$autosuggest_dir" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions |
        pipe_output 2
    success 2 "Installed Zsh-autosuggestions plugin."
else
    warn 2 "Zsh-autosuggestions plugin already installed, updating:"
    pull_output=$(git --git-dir="$autosuggest_dir/.git" pull)

    # Check if the repository was updated
    if [[ $pull_output == *"Already up to date"* ]]; then
        success 3 "Zsh-autosuggestions plugin is up to date."
    else
        success 3 "Zsh-autosuggestions plugin was updated."
    fi

fi
