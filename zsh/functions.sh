#!/bin/bash
#
# Custom functions

cdx() {
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

_cdx_completion() {
    local completions_dir="$HOME/projects"
    local current_word="${COMP_WORDS[COMP_CWORD]}"

    local completions=()
    for file in "$completions_dir"/*; do
        completions+=("$(basename "$file")")
    done

    COMPREPLY=($(compgen -W "${completions[*]}" -- "$current_word"))
}
complete -F _cdx_completion cdx
