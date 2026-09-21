#!/bin/sh

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
home=${HOME:?HOME must be set}

link_file() {
  source=$1
  target=$2

  if [ -L "$target" ] && [ "$(readlink "$target")" = "$source" ]; then
    return
  fi

  if [ -d "$target" ]; then
    printf 'Refusing to replace directory %s\n' "$target" >&2
    exit 1
  fi

  if [ -e "$target" ] || [ -L "$target" ]; then
    backup=$(mktemp "${target}.backup.XXXXXX")
    mv "$target" "$backup"
    printf 'Backed up %s to %s\n' "$target" "$backup"
  fi

  ln -s "$source" "$target"
  printf 'Linked %s to %s\n' "$target" "$source"
}

link_file "$script_dir/gitconfig.symlink" "$home/.gitconfig"
link_file "$script_dir/gitignore.symlink" "$home/.gitignore_global"
