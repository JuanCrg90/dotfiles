#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-installers.XXXXXX")
tmpdir=$(CDPATH= cd "$tmpdir" && pwd)
trap 'trash "$tmpdir"' EXIT HUP INT TERM
home="$tmpdir/home"
mock_bin="$tmpdir/bin"

mkdir -p "$home" "$mock_bin" "$tmpdir/gh" "$tmpdir/herdr" "$tmpdir/mise" "$tmpdir/nvim/nvim" "$tmpdir/pi" "$tmpdir/codex" "$tmpdir/rtk" "$tmpdir/iterm"
cp "$repo_dir/gh/install.sh" "$tmpdir/gh/install.sh"
cp "$repo_dir/herdr/config.toml" "$tmpdir/herdr/config.toml"
cp "$repo_dir/herdr/install.sh" "$tmpdir/herdr/install.sh"
cp "$repo_dir/mise/install.sh" "$tmpdir/mise/install.sh"
cp "$repo_dir/nvim/install.sh" "$tmpdir/nvim/install.sh"
cp "$repo_dir/pi/install.sh" "$tmpdir/pi/install.sh"
cp "$repo_dir/codex/install.sh" "$tmpdir/codex/install.sh"
cp "$repo_dir/rtk/install.sh" "$tmpdir/rtk/install.sh"
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
mock herdr 'exit 0'
mock fdfind 'exit 0'
mock curl '
printf "%s\\n" "$*" >> "$CURL_LOG"
case "$*" in
  *"rtk-ai/rtk"*)
    printf "%s\\n" "$*" >> "$RTK_LOG"
    printf "%s\\n" "mkdir -p \"\$RTK_INSTALL_DIR\"" "printf \"%s\\\\n\" \"#!/bin/sh\" \"exit 0\" > \"\$RTK_INSTALL_DIR/rtk\"" "chmod +x \"\$RTK_INSTALL_DIR/rtk\""
    ;;
  *"pi.dev/install.sh"*)
    printf "%s\\n" "mkdir -p \"\$HOME/.local/bin\"" ": > \"\$HOME/.local/bin/pi\"" "chmod +x \"\$HOME/.local/bin/pi\""
    ;;
  *"chatgpt.com/codex/install.sh"*)
    printf "%s\\n" "case \":\$PATH:\" in *\":\$HOME/.local/bin:\"*) ;; *) printf \"%s\\\\n\" modified >> \"\$HOME/.zshrc\" ;; esac" "mkdir -p \"\$HOME/.local/bin\"" ": > \"\$HOME/.local/bin/codex\"" "chmod +x \"\$HOME/.local/bin/codex\""
    ;;
  *)
    printf "unexpected curl command: %s\\n" "$*" >&2
    exit 1
    ;;
esac
'
mock mise '
case "$*" in
  "unuse --global pnpm")
    printf "%s\\n" "$*" >> "$MISE_LOG"
    ;;
  "use --global node@latest npm:pnpm@11.9.0")
    printf "%s\\n" "$*" >> "$MISE_LOG"
    ;;
  "--version")
    printf "%s\\n" "mise test"
    ;;
  "exec node@latest npm:pnpm@11.9.0 -- pnpm add --global tree-sitter-cli")
    printf "%s\\n" "$*" >> "$MISE_LOG"
    mkdir -p "$PNPM_HOME/bin"
    : > "$PNPM_HOME/bin/tree-sitter"
    chmod +x "$PNPM_HOME/bin/tree-sitter"
    ;;
  "exec node@latest npm:pnpm@11.9.0 -- pnpm bin --global")
    printf "%s\\n" "$PNPM_HOME/bin"
    ;;
  "exec node@latest -- sh -c curl -fsSL https://pi.dev/install.sh | sh")
    printf "%s\\n" "$*" >> "$MISE_LOG"
    "$4" "$5" "$6"
    ;;
  *)
    printf "unexpected mise command: %s\\n" "$*" >&2
    exit 1
    ;;
esac'

old_herdr_config="$tmpdir/old-herdr-config.toml"
: > "$old_herdr_config"
mkdir -p "$home/.config/herdr"
ln -s "$old_herdr_config" "$home/.config/herdr/config.toml"
PATH="$mock_bin:$PATH" HOME="$home" sh "$tmpdir/herdr/install.sh"

PATH="$mock_bin:$PATH" HOME="$home" MISE_LOG="$tmpdir/mise.log" sh "$tmpdir/mise/install.sh"
PATH="$mock_bin:$PATH" HOME="$home" MISE_LOG="$tmpdir/mise.log" sh "$tmpdir/nvim/install.sh"
PATH="$mock_bin:/usr/bin:/bin" HOME="$home" MOCK_BIN="$mock_bin" SNAP_LOG="$tmpdir/snap.log" sh "$tmpdir/gh/install.sh"
PATH="$mock_bin:/usr/bin:/bin" HOME="$home" RTK_LOG="$tmpdir/rtk.log" CURL_LOG="$tmpdir/curl.log" sh "$tmpdir/rtk/install.sh"
printf '%s\n' 'existing zsh config' > "$home/.zshrc"
PATH="$mock_bin:/usr/bin:/bin" HOME="$home" MISE_LOG="$tmpdir/mise.log" CURL_LOG="$tmpdir/curl.log" sh "$tmpdir/pi/install.sh"
external_home="$tmpdir/external-home"
external_bin="$tmpdir/external-bin"
mkdir -p "$external_home" "$external_bin"
printf '%s\n' '#!/bin/sh' 'exit 0' > "$external_bin/pi"
chmod +x "$external_bin/pi"
external_pi_output=$(PATH="$external_bin:$mock_bin:/usr/bin:/bin" HOME="$external_home" MISE_LOG="$tmpdir/external-mise.log" CURL_LOG="$tmpdir/external-curl.log" sh "$tmpdir/pi/install.sh")
printf '%s\n' "$external_pi_output" | grep -Fqx "Pi already installed: $external_bin/pi"
test ! -e "$external_home/.local/bin/pi"
PATH="$mock_bin:$PATH" HOME="$home" CURL_LOG="$tmpdir/curl.log" sh "$tmpdir/codex/install.sh"

test "$(readlink "$home/.config/herdr/config.toml")" = "$tmpdir/herdr/config.toml"
herdr_backup=$(find "$home/.config/herdr" -maxdepth 1 -type l -name 'config.toml.backup.*' -print)
test "$(readlink "$herdr_backup")" = "$old_herdr_config"
test -L "$home/.local/bin/tree-sitter"
test "$(readlink "$home/.local/bin/tree-sitter")" = "$home/.local/share/pnpm/bin/tree-sitter"
test "$(readlink "$home/.config/nvim")" = "$tmpdir/nvim/nvim"
grep -qx 'unuse --global pnpm' "$tmpdir/mise.log"
grep -qx 'use --global node@latest npm:pnpm@11.9.0' "$tmpdir/mise.log"
grep -qx 'exec node@latest npm:pnpm@11.9.0 -- pnpm add --global tree-sitter-cli' "$tmpdir/mise.log"
test -x "$mock_bin/gh"
grep -qx 'install gh --classic' "$tmpdir/snap.log"
test -x "$home/.local/bin/rtk"
grep -Fqx -- '-fsSL https://raw.githubusercontent.com/rtk-ai/rtk/refs/heads/master/install.sh' "$tmpdir/rtk.log"
test -x "$home/.local/bin/pi"
test -x "$home/.local/bin/codex"
grep -Fqx 'exec node@latest -- sh -c curl -fsSL https://pi.dev/install.sh | sh' "$tmpdir/mise.log"
grep -Fqx -- '-fsSL https://pi.dev/install.sh' "$tmpdir/curl.log"
grep -Fqx -- '-fsSL https://chatgpt.com/codex/install.sh' "$tmpdir/curl.log"
grep -Fqx 'existing zsh config' "$home/.zshrc"

output=$(PATH="$mock_bin:$PATH" HOME="$home" sh "$tmpdir/install.sh" --skip-mise --skip-pi --skip-codex --skip-herdr --skip-nvim --skip-zsh --skip-git --skip-gh --skip-rtk --skip-iterm)
printf '%s\n' "$output" | grep -Fqx '[SKIP] pi'
printf '%s\n' "$output" | grep -Fqx '[SKIP] codex'
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
