#!/usr/bin/env bash

#
# File: get_directory_size.zsh
#
# Description: Gets the directory size in either MB, KB, GB based on argument.
#
# Usage:
# get_directory_size.sh [OPTION] [-d "${PWD}"]
#
# -G Output in GB
# -M Output in MB
# -K Output in KB
#

function get_size_string() {
  declare -g -x dir_size_string
  dir_size_string=$(du \
    -l \
    --exclude "**/node_modules/**" \
    --exclude "**/vendor/**" \
    --exclude "**/dist/**" \
    --exclude "**/build/**" \
    -h \
    "$1" \
    -d 1 \
    | awk '{ print \$1 }' \
    | sed 's/M/000/g' \
    | sed 's/K/00/g')

  return dir_size_string
}

function get_size_array() {
  declare -g -x dir_size_array

  get_size_string | while read line; do
    dir_size_array+="$line"
  done
}

# vim: set et ts=2 sw=2 ft=bash:
