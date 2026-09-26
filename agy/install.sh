#!/bin/sh

set -eu

home=${HOME:?HOME must be set}
local_bin="$home/.local/bin"
agy_bin="$local_bin/agy"

if [ -x "$agy_bin" ]; then
  printf '%s\n' "agy already installed: $agy_bin"
  exit 0
fi

existing_agy=$(command -v agy 2>/dev/null || true)
if [ -n "$existing_agy" ] && [ -x "$existing_agy" ]; then
  printf '%s\n' "agy already installed: $existing_agy"
  exit 0
fi

command -v curl >/dev/null 2>&1 || {
  printf 'curl is required to install agy.\n' >&2
  exit 1
}

mkdir -p "$local_bin"
printf '%s\n' "Installing agy to $agy_bin..."

# the official install script uses bash
curl -fsSL https://antigravity.google/cli/install.sh | bash -s -- --dir "$local_bin"

if [ ! -x "$agy_bin" ]; then
  printf 'Error: agy not found after installation at %s.\n' "$agy_bin" >&2
  exit 1
fi

printf '%s\n' "agy installed: $agy_bin"
