#!/bin/bash
#
# Main setup script for dotfiles

DOTFILES="$HOME/projects/dotfiles"
source "$DOTFILES/install/utils.sh"

set -e

create_env_file() {
    info 0 "Creating env file:"
    if test -f "$HOME/.env.sh"; then
        warn 1 "$HOME/.env.sh file already exists, skipping"
    else
        echo "export DOTFILES=$DOTFILES" >$HOME/.env.sh
        success 1 'Created ~$HOME/.env.sh'
    fi
}

link() {
    info 0 "Linking files ($1)"
    while IFS= read -r line; do
        local src dst dir
        src=$(eval echo "$line" | cut -d '=' -f 1)
        dst=$(eval echo "$line" | cut -d '=' -f 2)
        dir=$(dirname $dst)

        mkdir -p "$dir"
        ln -sf "$src" "$dst"
        success 1 "Linked $src to $dst"

    done <"$1/links.props"
}

install() {
    source "$1/install.$2.sh"
}

install_packages() {
    # Whitelisted commands
    whitelist=("link" "install")

    find -H "$DOTFILES" -maxdepth 2 -name "*.module" -not -path '*.git*' | while read modulefile; do
        local src dst dir
        dir=$(dirname $modulefile)
        modulename=$(basename "$dir")
        modulename=$(echo "$modulename" | sed 's/\b\(.\)/\u\1/g')
        info 1 "Installing '$modulename' package"

        while IFS= read -r line; do
            if [[ "${whitelist[*]}" =~ (^| )"$line"($| ) ]]; then
                eval "$line" "$dir" $1 | pipe_output 2
            else
                echo "Unknown function: $line"
                exit 1
            fi
        done <"$modulefile"
    done
}

changeshell() {
    if [[ "$(basename "$SHELL")" != "zsh" ]]; then
        chsh -s "$(which zsh)"
        success 0 "Please relog in order for changes to take effect."
    fi
}

setup() {
    echo ' _____        _    __ _ _           '
    echo '|  __ \      | |  / _(_) |          '
    echo '| |  | | ___ | |_| |_ _| | ___  ___ '
    echo '| |  | |/ _ \| __|  _| | |/ _ \/ __|'
    echo '| |__| | (_) | |_| | | | |  __/\__ \'
    echo '|_____/ \___/ \__|_| |_|_|\___||___/'
    echo ''

    if [[ $(git status -s) != '' ]]; then
        if [[ $1 == "-f" ]]; then
            warn 0 "Uncommitted changes found, but continuing due to force flag."
        else
            fail 0 "Uncommitted changes found. Please commit changes before running script."
        fi
    fi

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        source /etc/os-release
        os_type="$ID"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        os_type="mac"
    fi
    info 0 "OS type: $os_type"

    create_env_file
    info 0 "Installing main dependencies"
    install "$DOTFILES/install" $os_type | pipe_output 1
    info 0 "Installing packages"
    install_packages $os_type
    changeshell
    success 0 'Successfully setup system!'
}

force_flag=$1
setup $force_flag
