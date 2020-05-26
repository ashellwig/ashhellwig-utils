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

set +o errexit
set +o nounset
set +o pipefail

function __get_size_string() {
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
}

function __get_size_array() {
  declare -g -x dir_size_array

  __get_size_string "$1" | while read -r line; do
    dir_size_array+="$line"
  done
}

function main() {
  declare -g -x use_gb
  use_gb=false
  declare -g -x use_mb
  use_mb=false
  declare -g -x use_kb
  use_kb=false
  declare -g -x dir_to_use
  dir_to_use=""

  while getopts ":hGMKd:" arg; do
    case "${arg}" in
      G)
        use_gb=false
        use_mb=false
        use_kb=false
        shift
        ;;
      M)
        use_gb=false
        use_mb=true
        use_kb=false
        shift
        ;;
      K)
        use_gb=false
        use_mb=false
        use_kb=true
        shift
        ;;
      d)
        dir_to_use="${OPTARG}"
        shift
        ;;
      h)
        echo -e "\033[1;31mYou need to specify [-G|-M|-K] -d [DIR]\033[0m"
        exit 0
        ;;
      ?)
        echo -e "\033[1;31mYou need to specify [-G|-M|-K] -d [DIR]\033[0m"
        exit 1
        ;;
      *)
        echo -e "\033[1;31mYou need to specify [-G|-M|-K] -d [DIR]\033[0m"
        exit 1
        ;;
    esac
  done

  if [[ "$use_gb" -eq 0 ]]; then

    declare -g -x DIR_SIZE_ARRAY
    DIR_SIZE_ARRAY="$(__get_size_array "${dir_to_use}")"

    declare -g -x gb_size

    for i in ${DIR_SIZE_ARRAY[*]}; do
      declare -g total_sum
      total_sum=$((total_sum + i))
    done

    gb_size=$((total_sum / 1000))

    echo "${gb_size}GB"
  fi
}

main

# --- Clean ---
# Global Variables
unset dir_size_string
unset dir_size_array
unset use_gb
unset use_mb
unset use_kb
unset dir_to_use
unset total_sum
unset DIR_SIZE_ARRAY

# Functions
unset __get_size_string
unset __get_size_array
unset main

# Options
set -o errexit
set -o nounset
set -o pipefail

# vim: set et ts=2 sw=2 ft=bash:
