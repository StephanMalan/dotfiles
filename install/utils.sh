#!/bin/bash
#
# Util functions for bash scripts

pipe_output() {
    while IFS= read -r line; do
        print_output "" "$1" "$line" # Add the prefix arguments to the echo statement
    done
}

info() {
    # printf "[ \033[00;34m..\033[0m ] $1\n"
    print_output "[\033[00;34mINFO\033[0m] " "$1" "$2"
}

warn() {
    print_output "[\033[0;33mWARN\033[0m] " "$1" "$2"
}

success() {
    print_output "[ \033[00;32mOK\033[0m ] " "$1" "$2"
}

fail() {
    print_output "[\033[0;31mFAIL\033[0m] " "$1" "$2"
    exit
}

print_output() {
    local prefix="$1"
    local tabs="$2"
    local text="$3"

    local indent=""
    for ((i = 0; i < tabs; i++)); do
        indent+="  "
    done

    echo -e "${indent}${prefix}${text}"
}
