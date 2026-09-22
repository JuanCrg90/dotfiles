#!/bin/sh

set -eu

if command -v gh >/dev/null 2>&1; then
  printf '%s\n' "GitHub CLI already installed: $(command -v gh)"
  exit 0
fi

case "$(uname -s)" in
  Darwin)
    command -v brew >/dev/null 2>&1 || {
      printf 'Homebrew is required on macOS.\n' >&2
      exit 1
    }
    printf '%s\n' "Installing GitHub CLI via Homebrew..."
    brew install gh
    ;;
  Linux)
    command -v snap >/dev/null 2>&1 || {
      printf 'Snap is required on Pop!_OS to install GitHub CLI.\n' >&2
      exit 1
    }
    if ! snap list gh >/dev/null 2>&1; then
      printf '%s\n' "Installing GitHub CLI via Snap..."
      sudo snap install gh --classic
    fi
    ;;
  *)
    printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2
    exit 1
    ;;
esac

if command -v gh >/dev/null 2>&1; then
  printf '%s\n' "GitHub CLI installed: $(command -v gh)"
elif [ -x /snap/bin/gh ]; then
  printf '%s\n' "GitHub CLI installed: /snap/bin/gh"
else
  printf '%s\n' "Error: GitHub CLI not found after installation.\n" >&2
  exit 1
fi
