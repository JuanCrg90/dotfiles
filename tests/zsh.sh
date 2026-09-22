#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
output=$(zsh -dfc 'source "$1"' zsh "$repo_dir/zsh/alias.sh" 2>&1)

if [ -n "$output" ]; then
  printf '%s\n' "$output" >&2
  exit 1
fi

printf '%s\n' 'zsh alias startup test passed'
