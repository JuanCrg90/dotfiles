#!/bin/sh

set -eu

home=${HOME:?HOME must be set}
local_bin="$home/.local/bin"
codex_bin="$local_bin/codex"

if [ -x "$codex_bin" ]; then
  printf '%s\n' "Codex already installed: $codex_bin"
  exit 0
fi

command -v curl >/dev/null 2>&1 || {
  printf 'curl is required to install Codex.\n' >&2
  exit 1
}

mkdir -p "$local_bin"
printf '%s\n' "Installing Codex to $codex_bin..."
# ~/.local/bin is already managed by zsh/.zshenv. Keep it on PATH so the
# official installer does not append a duplicate block to a shell profile.
curl -fsSL https://chatgpt.com/codex/install.sh | \
  PATH="$local_bin:/usr/bin:/bin" CODEX_INSTALL_DIR="$local_bin" CODEX_NON_INTERACTIVE=1 sh

if [ ! -x "$codex_bin" ]; then
  printf 'Error: Codex not found after installation at %s.\n' "$codex_bin" >&2
  exit 1
fi

printf '%s\n' "Codex installed: $codex_bin"
printf '%s\n' "Run codex to authenticate."
