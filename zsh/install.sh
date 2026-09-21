#!/usr/bin/env sh
set -eu

repo_dir=$(CDPATH= cd -P "$(dirname "$0")" && pwd)
oh_my_zsh_dir=${ZSH:-"$HOME/.oh-my-zsh"}
theme_dir="$oh_my_zsh_dir/custom/themes/powerlevel10k"

missing=0
for command in zsh git mise; do
  if ! command -v "$command" >/dev/null 2>&1; then
    printf 'Missing required command: %s\n' "$command" >&2
    missing=1
  fi
done

if [ "$missing" -ne 0 ]; then
  printf '%s\n' 'Install missing prerequisites with your system package manager, then rerun this script.' >&2
  exit 1
fi

clone_if_missing() {
  repository=$1
  destination=$2

  if [ -e "$destination" ]; then
    destination_root=$(CDPATH= cd -P "$destination" && pwd)
    if [ -d "$destination/.git" ] && [ "$(git -C "$destination" rev-parse --show-toplevel 2>/dev/null)" = "$destination_root" ]; then
      return
    fi

    printf 'Expected a complete Git repository at %s; refusing to overwrite it.\n' "$destination" >&2
    exit 1
  fi

  git clone --depth=1 "$repository" "$destination"
}

link_if_safe() {
  source_file=$1
  target_file=$2

  if [ -L "$target_file" ]; then
    if [ "$target_file" -ef "$source_file" ]; then
      return
    fi

    printf 'Existing symlink %s points elsewhere; refusing to overwrite it.\n' "$target_file" >&2
    exit 1
  fi

  if [ -e "$target_file" ]; then
    printf 'Existing file %s; move it aside before running this script.\n' "$target_file" >&2
    exit 1
  fi

  ln -s "$source_file" "$target_file"
}

clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$oh_my_zsh_dir"
clone_if_missing https://github.com/romkatv/powerlevel10k.git "$theme_dir"

link_if_safe "$repo_dir/.zshrc" "$HOME/.zshrc"
link_if_safe "$repo_dir/.zshenv" "$HOME/.zshenv"

printf '%s\n' 'Zsh configuration installed.'
