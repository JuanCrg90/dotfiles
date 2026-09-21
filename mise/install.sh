#!/bin/sh

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
home=${HOME:?HOME must be set}

install_mise() {
  command -v mise >/dev/null 2>&1 && return

  case "$(uname -s)" in
    Darwin)
      command -v brew >/dev/null 2>&1 || {
        printf 'Homebrew is required on macOS.\n' >&2
        exit 1
      }
      printf '%s\n' "Installing mise via Homebrew..."
      brew install mise
      ;;
    Linux)
      if command -v snap >/dev/null 2>&1; then
        printf '%s\n' "Installing mise via Snap..."
        sudo snap install mise --classic
      elif command -v apt-get >/dev/null 2>&1; then
        printf '%s\n' "Installing mise via official installer..."
        curl -fsSL https://mise.run | sh
      else
        printf '%s\n' "No supported package manager found; running official installer..."
        curl -fsSL https://mise.run | sh
      fi
      ;;
    *)
      printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2
      exit 1
      ;;
  esac

  command -v mise >/dev/null 2>&1 || {
    printf 'Error: mise not found after installation.\n' >&2
    exit 1
  }
}

setup_pnpm() {
  mise use --global pnpm >/dev/null 2>&1
  mise trust "$script_dir" 2>/dev/null || true
}

install_mise
setup_pnpm

printf '%s\n' "mise installed: $(command -v mise) ($(mise --version 2>/dev/null || echo "version unknown"))"
printf '%s\n' "pnpm managed by mise; run 'mise install pnpm' to ensure pnpm is available."
