#!/bin/bash
#
# Custom functions

cdp() {
    deactivate >/dev/null 2>&1
    local project
    project=$(find "$HOME/projects/." -maxdepth 1 -type d -name "$1*" -print -quit)
    if [ -z "$project" ]; then
        echo "Project not found!"
        return 1
    else
        cd $project
        act >/dev/null 2>&1
        return 0
    fi
}

_cdp_completion() {
    local completions_dir="$HOME/projects"
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    local completions=()
    for file in "$completions_dir"/*; do
        completions+=("$(basename "$file")")
    done

    COMPREPLY=($(compgen -W "${completions[*]}" -- "$current_word"))
}
complete -o nospace -F _cdp_completion cdp

chkp() {
    has_changes=false

    # Loop through each directory in the source directory
    for dir in "$HOME/projects"/*; do
        if [ -d "$dir" ] && [ -d "$dir/.git" ]; then
            cd "$dir" || continue

            # Check if there are any uncommitted changes
            if ! git diff-index --quiet HEAD --; then
                echo "\033[0;33m ± \033[0m Uncommitted changes in directory: $dir"
                has_changes=true
            fi

            # Check if there are any unpushed commits
            if git rev-parse --abbrev-ref --symbolic-full-name @{u} >/dev/null 2>&1; then
                LOCAL=$(git rev-parse @)
                REMOTE=$(git rev-parse "@{u}")

                if [ "$LOCAL" != "$REMOTE" ]; then
                    echo "\033[0;31m \u21b0 \033[0m There are unsynced commits in directory: $dir"
                    has_changes=true
                fi
            fi

            cd - >/dev/null || exit
        fi
    done

    if [ "$has_changes" = false ]; then
        echo "\033[0;32m \ue0a0 \033[0m All directories are up to date"
    fi
}

install_spotify() {
    echo 'Downloading service file'
    wget https://raw.githubusercontent.com/Spotifyd/spotifyd/master/contrib/spotifyd.service -O $HOME/.config/systemd/user/spotifyd.service -q

    echo -n Enter Spotify username:
    read username
    echo -n Enter Spotify password:
    read -s password
    echo

    echo 'Setting up config file'
    mkdir -p "$HOME/.config/spotifyd"
    config_file="$HOME/.config/spotifyd/spotifyd.conf"
    echo '[global]' >$config_file
    echo "username = \"$username\"" >>$config_file
    echo '' >>$config_file
    echo "password = \"$password\"" >>$config_file
    systemctl --user enable spotifyd.service --now

    echo '\033[00;32m\uf00c\033[0m Done'

}
