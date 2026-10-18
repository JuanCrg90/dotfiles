#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
config_dir="${XDG_CONFIG_HOME:-${HOME:?HOME must be set}/.config}/ghostty"
source_file="$repo_dir/config.ghostty"
target_file="$config_dir/config.ghostty"

# Check both filenames before moving anything; symlinks are backed up as links.
for config_file in "$config_dir/config" "$target_file"; do
  if [ -d "$config_file" ] && [ ! -L "$config_file" ]; then
    printf 'Refusing to replace directory %s\n' "$config_file" >&2
    exit 1
  fi
done

if ! command -v ghostty >/dev/null 2>&1; then
  printf '%s\n' 'Installing Ghostty via Snap...'
  sudo snap install ghostty --classic
  if ! command -v ghostty >/dev/null 2>&1; then
    printf '%s\n' 'Ghostty installed but not found on PATH; add /snap/bin to PATH and rerun.' >&2
    exit 1
  fi
fi

mkdir -p "$config_dir"
for config_file in "$config_dir/config" "$target_file"; do
  if [ "$config_file" = "$target_file" ] && [ -L "$config_file" ] && [ "$config_file" -ef "$source_file" ]; then
    continue
  fi

  if [ -e "$config_file" ] || [ -L "$config_file" ]; then
    backup_file=$(mktemp "${config_file}.backup.XXXXXX")
    mv "$config_file" "$backup_file"
    printf 'Backed up existing config to %s\n' "$backup_file"
  fi
done

if [ -L "$target_file" ] && [ "$target_file" -ef "$source_file" ]; then
  printf '%s\n' 'Ghostty configuration already installed.'
else
  ln -s "$source_file" "$target_file"
  printf '%s\n' 'Ghostty configuration installed. Restart Ghostty to apply.'
fi
