#!/bin/sh

set -eu

home=${HOME:?HOME must be set}
local_bin="$home/.local/bin"
pi_bin="$local_bin/pi"

if [ -x "$pi_bin" ]; then
  printf '%s\n' "Pi already installed: $pi_bin"
  exit 0
fi

existing_pi=$(command -v pi 2>/dev/null || true)
if [ -n "$existing_pi" ] && [ -x "$existing_pi" ]; then
  printf '%s\n' "Pi already installed: $existing_pi"
  exit 0
fi

command -v mise >/dev/null 2>&1 || {
  printf 'mise is required to install Pi. Run mise/install.sh first.\n' >&2
  exit 1
}

command -v curl >/dev/null 2>&1 || {
  printf 'curl is required to install Pi.\n' >&2
  exit 1
}

mkdir -p "$local_bin"
printf '%s\n' "Installing Pi to $pi_bin with mise-managed Node.js..."
PATH="$local_bin:$PATH" mise exec node@latest -- sh -c 'curl -fsSL https://pi.dev/install.sh | sh'

if [ ! -x "$pi_bin" ]; then
  printf 'Error: Pi not found after installation at %s.\n' "$pi_bin" >&2
  exit 1
fi

printf '%s\n' "Pi installed: $pi_bin"
printf '%s\n' "Run pi and use /login to authenticate."
