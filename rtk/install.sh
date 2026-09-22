#!/bin/sh

set -eu

home=${HOME:?HOME must be set}
local_bin="$home/.local/bin"
rtk_bin="$local_bin/rtk"

if [ -x "$rtk_bin" ]; then
  printf '%s\n' "rtk already installed: $rtk_bin"
  exit 0
fi

command -v curl >/dev/null 2>&1 || {
  printf 'curl is required to install rtk.\n' >&2
  exit 1
}

printf '%s\n' "Installing rtk to $rtk_bin..."
curl -fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh | RTK_INSTALL_DIR="$local_bin" sh

if [ ! -x "$rtk_bin" ]; then
  printf 'Error: rtk not found after installation at %s.\n' "$rtk_bin" >&2
  exit 1
fi

printf '%s\n' "rtk installed: $rtk_bin"
printf '%s\n' "Open a new shell to use rtk from ~/.local/bin."
