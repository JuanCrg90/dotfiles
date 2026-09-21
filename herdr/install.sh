#!/bin/sh

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
home=${HOME:?HOME must be set}
config_dir="$home/.config/herdr"
config_file="$config_dir/config.toml"
herdr_bin="herdr"

# Check if herdr is already installed
if command -v "$herdr_bin" >/dev/null 2>&1; then
  printf '%s\n' "herdr is already installed: $(command -v "$herdr_bin")"
else
  # Try Homebrew first on macOS
  if [ "$(uname)" = "Darwin" ] && command -v brew >/dev/null 2>&1; then
    printf '%s\n' "Installing herdr via Homebrew..."
    brew install herdr
  elif [ "$(uname)" = "Darwin" ]; then
    # macOS without Homebrew: use official installer
    printf '%s\n' "Installing herdr via official installer..."
    curl -fsSL https://herdr.dev/install.sh | sh
  elif command -v apt-get >/dev/null 2>&1; then
    # Pop!_OS / Debian-based: use official installer
    printf '%s\n' "Installing herdr via official installer..."
    curl -fsSL https://herdr.dev/install.sh | sh
  else
    printf '%s\n' "No supported package manager found; running official installer..."
    curl -fsSL https://herdr.dev/install.sh | sh
  fi

  # Verify installation
  if ! command -v "$herdr_bin" >/dev/null 2>&1; then
    printf '%s\n' "Error: herdr not found after installation." >&2
    printf '%s\n' "Ensure ~/.local/bin or /usr/local/bin is on your PATH, then restart your shell." >&2
    exit 1
  fi

  printf '%s\n' "herdr installed: $(command -v "$herdr_bin") ($(herdr --version 2>/dev/null || echo "version unknown"))"
fi

# Symlink config.toml
if [ -L "$config_file" ] && [ "$(readlink "$config_file")" = "$script_dir/config.toml" ]; then
  printf '%s\n' "Config already linked: $config_file -> $script_dir/config.toml"
elif [ -L "$config_file" ]; then
  printf '%s\n' "Refusing to replace existing symlink at $config_file" >&2
  printf '%s\n' "Remove or update the symlink manually before rerunning this script." >&2
  exit 1
elif [ -e "$config_file" ]; then
  backup="${config_file}.backup.$(date +%Y%m%d%H%M%S)"
  cp "$config_file" "$backup"
  printf '%s\n' "Backed up existing config to $backup"
  ln -s "$script_dir/config.toml" "$config_file"
  printf '%s\n' "Linked config: $config_file -> $script_dir/config.toml"
else
  mkdir -p "$config_dir"
  ln -s "$script_dir/config.toml" "$config_file"
  printf '%s\n' "Linked config: $config_file -> $script_dir/config.toml"
fi

printf '%s\n' "Herdr setup complete."
