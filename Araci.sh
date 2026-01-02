#!/bin/sh
printf '\033c\033]0;%s\a' Araci
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Araci.x86_64" "$@"
