#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-installers.XXXXXX")
tmpdir=$(CDPATH= cd "$tmpdir" && pwd)
trap 'trash "$tmpdir"' EXIT HUP INT TERM
home="$tmpdir/home"
mock_bin="$tmpdir/bin"

mkdir -p "$home" "$mock_bin" "$tmpdir/gh" "$tmpdir/mise" "$tmpdir/nvim/nvim" "$tmpdir/iterm"
cp "$repo_dir/gh/install.sh" "$tmpdir/gh/install.sh"
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
mock snap '
case "$*" in
  "list nvim")
    exit 0
    ;;
  "list gh")
    exit 1
    ;;
  "install gh --classic")
    printf "%s\\n" "$*" >> "$SNAP_LOG"
    printf "%s\\n" "#!/bin/sh" "exit 0" > "$MOCK_BIN/gh"
    chmod +x "$MOCK_BIN/gh"
    ;;
  *)
    exit 0
    ;;
esac'
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
PATH="$mock_bin:/usr/bin:/bin" HOME="$home" MOCK_BIN="$mock_bin" SNAP_LOG="$tmpdir/snap.log" sh "$tmpdir/gh/install.sh"

test -L "$home/.local/bin/tree-sitter"
test "$(readlink "$home/.local/bin/tree-sitter")" = "$home/.local/share/pnpm/bin/tree-sitter"
test "$(readlink "$home/.config/nvim")" = "$tmpdir/nvim/nvim"
grep -qx 'unuse --global pnpm' "$tmpdir/mise.log"
grep -qx 'use --global node@latest npm:pnpm@latest' "$tmpdir/mise.log"
grep -qx 'exec node@latest npm:pnpm@latest -- pnpm add --global tree-sitter-cli' "$tmpdir/mise.log"
test -x "$mock_bin/gh"
grep -qx 'install gh --classic' "$tmpdir/snap.log"

output=$(PATH="$mock_bin:$PATH" HOME="$home" sh "$tmpdir/install.sh" --skip-mise --skip-herdr --skip-nvim --skip-zsh --skip-git --skip-gh --skip-iterm)
printf '%s\n' "$output" | grep -Fqx '[SKIP] uhk (use --with-uhk)'

mock_bin="$tmpdir/mac-bin"
mkdir -p "$mock_bin"
mock uname 'printf "%s\\n" Darwin'
mock brew '
case "$*" in
  "install gh")
    printf "%s\\n" "$*" >> "$BREW_LOG"
    printf "%s\\n" "#!/bin/sh" "exit 0" > "$MOCK_GH"
    chmod +x "$MOCK_GH"
    ;;
  *)
    exit 1
    ;;
esac'
PATH="$mock_bin:/usr/bin:/bin" HOME="$home" BREW_LOG="$tmpdir/brew.log" MOCK_GH="$mock_bin/gh" sh "$tmpdir/gh/install.sh"
test -x "$mock_bin/gh"
grep -qx 'install gh' "$tmpdir/brew.log"

printf '%s\n' 'installer regression tests passed'
