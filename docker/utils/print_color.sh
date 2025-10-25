#!/usr/bin/env bash

set -e

function print_color {
    tput setaf $1
    echo "$2"
    tput sgr0
}

function print_error {
    print_color 1 "$1"
}

function print_warning {
    print_color 3 "$1"
}

function print_info {
    print_color 2 "$1"
}

##################################
# tput color table for reference #
##################################
# Color  Value 
# black    0
# red      1
# green    2
# yellow   3
# blue     4
# magenta  5
# cyan     6 
# white    7
