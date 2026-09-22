#!/bin/sh

set -eu

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
  printf '%s\n' "Configuring Node.js and pnpm through mise..."
  mise unuse --global pnpm || true
  mise use --global node@latest npm:pnpm@latest
}

install_mise
setup_pnpm

printf '%s\n' "mise installed: $(command -v mise) ($(mise --version 2>/dev/null || echo "version unknown"))"
printf '%s\n' "Node.js and pnpm are managed by mise; pnpm installs global CLI packages."
