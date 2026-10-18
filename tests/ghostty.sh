#!/bin/sh
set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-ghostty.XXXXXX")
trap 'if command -v trash >/dev/null 2>&1; then trash "$tmpdir"; else printf "Test temp dir: %s\n" "$tmpdir"; fi' 0

mock_bin="$tmpdir/bin"
snap_bin="$tmpdir/snap-bin"
mkdir -p "$mock_bin" "$snap_bin"
printf '%s\n' '#!/bin/sh' 'exit 0' > "$mock_bin/ghostty"
printf '%s\n' '#!/bin/sh' 'echo "Unexpected installation" >&2; exit 1' > "$mock_bin/sudo"
chmod +x "$mock_bin/ghostty" "$mock_bin/sudo"
install_path="$mock_bin:$PATH"

install_config() {
  HOME="$tmpdir/home" XDG_CONFIG_HOME="$config_home" PATH="$install_path" \
    SNAP_LOG="$tmpdir/snap.log" MOCK_BIN="$snap_bin" SNAP_FAIL="${SNAP_FAIL:-0}" \
    /bin/sh "$repo_dir/ghostty/install.sh"
}

assert_refused() {
  if install_config >"$tmpdir/output" 2>&1; then
    printf 'Expected refusal for %s\n' "$config_home" >&2
    exit 1
  fi
  grep -q 'Refusing to replace directory' "$tmpdir/output"
}

assert_backed_up() {
  original=$1
  set -- "$original".backup.??????
  test "$#" -eq 1
  backup_file=$1
  test -e "$backup_file" || test -L "$backup_file"
  test "$config_home/ghostty/config.ghostty" -ef "$repo_dir/ghostty/config.ghostty"
  grep -Fq "Backed up existing config to $backup_file" "$tmpdir/output"
}

# A fresh HOME must not require an existing .config directory.
config_home=
install_config
target="$tmpdir/home/.config/ghostty/config.ghostty"
test -L "$target"
test "$(readlink "$target")" = "$repo_dir/ghostty/config.ghostty"
install_config
test "$target" -ef "$repo_dir/ghostty/config.ghostty"

# Custom XDG locations (including spaces) must be created and respected.
config_home="$tmpdir/custom config"
install_config
test "$config_home/ghostty/config.ghostty" -ef "$repo_dir/ghostty/config.ghostty"

config_home="$tmpdir/existing-file"
mkdir -p "$config_home/ghostty"
printf '%s\n' 'font-size = 15' > "$config_home/ghostty/config.ghostty"
install_config >"$tmpdir/output"
assert_backed_up "$config_home/ghostty/config.ghostty"
test ! -L "$backup_file"
grep -Fqx 'font-size = 15' "$backup_file"
install_config
set -- "$config_home/ghostty/config.ghostty".backup.??????
test "$#" -eq 1

config_home="$tmpdir/existing-directory"
mkdir -p "$config_home/ghostty/config.ghostty"
assert_refused
test -d "$config_home/ghostty/config.ghostty"

for kind in foreign dangling; do
  config_home="$tmpdir/$kind-symlink"
  mkdir -p "$config_home/ghostty"
  source_file="$tmpdir/$kind-target"
  if [ "$kind" = foreign ]; then
    printf '%s\n' 'existing config' > "$source_file"
  fi
  ln -s "$source_file" "$config_home/ghostty/config.ghostty"
  install_config >"$tmpdir/output"
  assert_backed_up "$config_home/ghostty/config.ghostty"
  test "$(readlink "$backup_file")" = "$source_file"
  if [ "$kind" = foreign ]; then
    grep -Fqx 'existing config' "$source_file"
  fi
done

for kind in file symlink dangling; do
  config_home="$tmpdir/legacy-$kind"
  mkdir -p "$config_home/ghostty"
  if [ "$kind" = file ]; then
    printf '%s\n' 'font-size = 16' > "$config_home/ghostty/config"
  else
    source_file="$tmpdir/legacy-$kind-target"
    if [ "$kind" = symlink ]; then
      : > "$source_file"
    fi
    ln -s "$source_file" "$config_home/ghostty/config"
  fi
  install_config >"$tmpdir/output"
  assert_backed_up "$config_home/ghostty/config"
  test ! -e "$config_home/ghostty/config"
  test ! -L "$config_home/ghostty/config"
  if [ "$kind" = file ]; then
    grep -Fqx 'font-size = 16' "$backup_file"
  else
    test "$(readlink "$backup_file")" = "$source_file"
  fi
done

# Moving a relative symlink must not change which file it resolves to.
config_home="$tmpdir/relative-symlink"
mkdir -p "$config_home/ghostty"
printf '%s\n' 'relative config' > "$tmpdir/relative-target"
ln -s '../../relative-target' "$config_home/ghostty/config.ghostty"
install_config >"$tmpdir/output"
assert_backed_up "$config_home/ghostty/config.ghostty"
test "$(readlink "$backup_file")" = '../../relative-target'
test "$backup_file" -ef "$tmpdir/relative-target"

# Preserve both filenames independently when both exist.
config_home="$tmpdir/both configs"
mkdir -p "$config_home/ghostty"
printf '%s\n' 'font-size = 17' > "$config_home/ghostty/config"
printf '%s\n' 'font-size = 18' > "$config_home/ghostty/config.ghostty"
install_config >"$tmpdir/output"
assert_backed_up "$config_home/ghostty/config"
grep -Fqx 'font-size = 17' "$backup_file"
assert_backed_up "$config_home/ghostty/config.ghostty"
grep -Fqx 'font-size = 18' "$backup_file"

# A directory conflict must fail before moving either config.
config_home="$tmpdir/legacy-directory"
mkdir -p "$config_home/ghostty/config"
printf '%s\n' 'font-size = 19' > "$config_home/ghostty/config.ghostty"
assert_refused
grep -Fqx 'font-size = 19' "$config_home/ghostty/config.ghostty"
test -d "$config_home/ghostty/config"

# Hide the real Ghostty and Snap binaries; no network or sudo in tests.
for utility in dirname mkdir mktemp mv ln chmod; do
  ln -s "$(command -v "$utility")" "$snap_bin/$utility"
done
printf '%s\n' '#!/bin/sh' 'printf "%s\n" "$*" >> "$SNAP_LOG"' 'exec "$@"' > "$snap_bin/sudo"
printf '%s\n' '#!/bin/sh' \
  '[ "$*" = "install ghostty --classic" ] || exit 1' \
  '[ "$SNAP_FAIL" = 0 ] || exit 1' \
  'printf "%s\n" "#!/bin/sh" "exit 0" > "$MOCK_BIN/ghostty"' \
  'chmod +x "$MOCK_BIN/ghostty"' > "$snap_bin/snap"
chmod +x "$snap_bin/sudo" "$snap_bin/snap"
install_path="$snap_bin"

# Failed application installation must leave existing configs untouched.
config_home="$tmpdir/failed-install"
mkdir -p "$config_home/ghostty"
printf '%s\n' 'font-size = 20' > "$config_home/ghostty/config.ghostty"
if SNAP_FAIL=1 install_config >"$tmpdir/output" 2>&1; then
  printf '%s\n' 'Expected Snap failure' >&2
  exit 1
fi
grep -Fqx 'font-size = 20' "$config_home/ghostty/config.ghostty"
test ! -e "$snap_bin/ghostty"

config_home="$tmpdir/snap-install"
install_config >"$tmpdir/output"
test -x "$snap_bin/ghostty"
test "$config_home/ghostty/config.ghostty" -ef "$repo_dir/ghostty/config.ghostty"
grep -Fqx 'snap install ghostty --classic' "$tmpdir/snap.log"
cp "$tmpdir/snap.log" "$tmpdir/snap-before.log"
install_config
cmp "$tmpdir/snap.log" "$tmpdir/snap-before.log"

printf '%s\n' 'Ghostty installer tests passed'
