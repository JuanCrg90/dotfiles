#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
output=$(zsh -dfc 'source "$1"' zsh "$repo_dir/zsh/alias.sh" 2>&1)

if [ -n "$output" ]; then
  printf '%s\n' "$output" >&2
  exit 1
fi

tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-zsh.XXXXXX")
trap 'trash "$tmpdir"' EXIT HUP INT TERM
mock_bin="$tmpdir/bin"
pnpm_global_bin="$tmpdir/pnpm/bin"
mkdir -p "$mock_bin" "$pnpm_global_bin"

printf '%s\n' '#!/bin/sh' 'printf "%s\\n" ":"' > "$mock_bin/mise"
printf '%s\n' '#!/bin/sh' 'case "$*" in "bin --global") printf "%s\\n" "$PNPM_GLOBAL_BIN" ;; *) exit 1 ;; esac' > "$mock_bin/pnpm"
chmod +x "$mock_bin/mise" "$mock_bin/pnpm"

PATH="$mock_bin:/usr/bin:/bin" HOME="$tmpdir/home" PNPM_GLOBAL_BIN="$pnpm_global_bin" \
  zsh -dfc 'source "$1"; (( ${path[(Ie)$PNPM_GLOBAL_BIN]} ))' zsh "$repo_dir/zsh/.zshrc"

printf '%s\n' 'zsh startup tests passed'
