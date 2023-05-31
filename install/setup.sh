#!/bin/bash
#
# Main setup script for dotfiles

cd "$(dirname "$0")/.."
DOTFILES=$(pwd -P)
source "$DOTFILES/install/utils.sh"

set -e

link_files() {
    info 0 "Starting file linking process:"

    if [[ $(git status -s) != '' ]]; then
        if [[ $1 == "-f" ]]; then
            warn 1 "Uncommitted changes found, but continuing due to force flag."
        else
            fail 1 "Uncommitted changes found. Please commit changes before running script."
        fi
    fi

    find -H "$DOTFILES" -maxdepth 2 -name 'links.props' -not -path '*.git*' | while read linkfile; do
        cat "$linkfile" | while IFS= read -r line; do
            local src dst dir
            src=$(eval echo "$line" | cut -d '=' -f 1)
            dst=$(eval echo "$line" | cut -d '=' -f 2)
            dir=$(dirname $dst)

            mkdir -p "$dir"
            ln -sf "$src" "$dst"
            success 1 "Linked $src to $dst"
        done
    done

    success 1 "Finished linking files"
}

create_env_file() {
    info 0 "Creating env file:"
    if test -f "$HOME/.env.sh"; then
        warn 1 "$HOME/.env.sh file already exists, skipping"
    else
        echo "export DOTFILES=$DOTFILES" >$HOME/.env.sh
        success 1 'Created ~$HOME/.env.sh'
    fi
}

install() {
    info 0 "Start installation process:"
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        os_type=$(cat /etc/issue | awk '{print $1}')
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        os_type="mac"
    fi
    info 1 "OS type: $os_type"
    echo ""

    main_install="$DOTFILES/install/main-install.${os_type,,}.sh"
    info 1 "Installing main dependecies from: $main_install"
    source $main_install | pipe_output 2
    success 2 "Finished intalling from: $main_install"
    echo ""

    find -H "$DOTFILES" -maxdepth 2 -name "install.${os_type,,}.sh" -not -path '*.git*' | while read installfile; do
        info 1 "Installing from: $installfile"
        source $installfile | pipe_output 2
        success 2 "Finished installing from: $main_install"
        echo ""
    done
    success 1 "Finished installing."
}

force_flag=$1
link_files $force_flag
echo ''
create_env_file
echo ''
install
echo ''
success 0 'Successfully setup system!'
