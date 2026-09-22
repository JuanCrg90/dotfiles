#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-installers.XXXXXX")
tmpdir=$(CDPATH= cd "$tmpdir" && pwd)
trap 'trash "$tmpdir"' EXIT HUP INT TERM
home="$tmpdir/home"
mock_bin="$tmpdir/bin"

mkdir -p "$home" "$mock_bin" "$tmpdir/mise" "$tmpdir/nvim/nvim" "$tmpdir/iterm"
cp "$repo_dir/mise/install.sh" "$tmpdir/mise/install.sh"
cp "$repo_dir/nvim/install.sh" "$tmpdir/nvim/install.sh"
cp "$repo_dir/install.sh" "$tmpdir/install.sh"
cp "$repo_dir/iterm/Profiles.json" "$tmpdir/iterm/Profiles.json"
cp "$repo_dir/iterm/monokai_tasty.itermcolors" "$tmpdir/iterm/monokai_tasty.itermcolors"

mock() {
  name=$1
  shift
  path="$mock_bin/$name"
  {
    printf '%s\n' '#!/bin/sh'
    printf '%s\n' "$*"
  } > "$path"
  chmod +x "$path"
}

mock uname 'printf "%s\\n" Linux'
mock sudo 'exec "$@"'
mock apt-get 'exit 0'
mock snap 'exit 0'
mock nvim 'printf "%s\\n" "NVIM v0.12.5"'
mock fdfind 'exit 0'
mock mise '
case "$*" in
  "unuse --global pnpm")
    printf "%s\\n" "$*" >> "$MISE_LOG"
    ;;
  "use --global node@latest npm:pnpm@latest")
    printf "%s\\n" "$*" >> "$MISE_LOG"
    ;;
  "--version")
    printf "%s\\n" "mise test"
    ;;
  "exec node@latest npm:pnpm@latest -- pnpm add --global tree-sitter-cli")
    printf "%s\\n" "$*" >> "$MISE_LOG"
    mkdir -p "$PNPM_HOME/bin"
    : > "$PNPM_HOME/bin/tree-sitter"
    chmod +x "$PNPM_HOME/bin/tree-sitter"
    ;;
  "exec node@latest npm:pnpm@latest -- pnpm bin --global")
    printf "%s\\n" "$PNPM_HOME/bin"
    ;;
  *)
    printf "unexpected mise command: %s\\n" "$*" >&2
    exit 1
    ;;
esac'

PATH="$mock_bin:$PATH" HOME="$home" MISE_LOG="$tmpdir/mise.log" sh "$tmpdir/mise/install.sh"
PATH="$mock_bin:$PATH" HOME="$home" MISE_LOG="$tmpdir/mise.log" sh "$tmpdir/nvim/install.sh"

test -L "$home/.local/bin/tree-sitter"
test "$(readlink "$home/.local/bin/tree-sitter")" = "$home/.local/share/pnpm/bin/tree-sitter"
test "$(readlink "$home/.config/nvim")" = "$tmpdir/nvim/nvim"
grep -qx 'unuse --global pnpm' "$tmpdir/mise.log"
grep -qx 'use --global node@latest npm:pnpm@latest' "$tmpdir/mise.log"
grep -qx 'exec node@latest npm:pnpm@latest -- pnpm add --global tree-sitter-cli' "$tmpdir/mise.log"

output=$(PATH="$mock_bin:$PATH" HOME="$home" sh "$tmpdir/install.sh" --skip-mise --skip-herdr --skip-nvim --skip-zsh --skip-git --skip-iterm)
printf '%s\n' "$output" | grep -Fqx '[SKIP] uhk (use --with-uhk)'

printf '%s\n' 'installer regression tests passed'
