#!/bin/sh

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
home=${HOME:?HOME must be set}
config_dir="$home/.config"
config_source="$script_dir/nvim"
config_target="$config_dir/nvim"
minimum_nvim_version=0.11.2

version_at_least() {
  awk -v have="$1" -v required="$2" '
    BEGIN {
      split(have, have_parts, ".")
      split(required, required_parts, ".")
      for (part = 1; part <= 3; part++) {
        if (have_parts[part] + 0 > required_parts[part] + 0) exit 0
        if (have_parts[part] + 0 < required_parts[part] + 0) exit 1
      }
      exit 0
    }
  '
}

install_tree_sitter() {
  command -v tree-sitter >/dev/null 2>&1 && return

  if ! command -v mise >/dev/null 2>&1; then
    printf '%s\n' "mise is required for tree-sitter-cli; install it with mise/install.sh first." >&2
    exit 1
  fi

  mise install tree-sitter-cli
}

install_packages() {
  case "$(uname -s)" in
    Darwin)
      command -v brew >/dev/null 2>&1 || {
        printf 'Homebrew is required on macOS.\n' >&2
        exit 1
      }
      brew install neovim ripgrep fd tree-sitter
      ;;
    Linux)
      command -v apt-get >/dev/null 2>&1 || {
        printf 'This installer supports Pop!_OS through APT and Snap.\n' >&2
        exit 1
      }
      command -v snap >/dev/null 2>&1 || {
        printf 'Snap is required on Pop!_OS to install Neovim.\n' >&2
        exit 1
      }
      sudo apt-get update
      sudo apt-get install -y ripgrep fd-find wl-clipboard xclip build-essential
      if ! snap list nvim >/dev/null 2>&1; then
        sudo snap install nvim --classic
      fi
      if [ -x /snap/bin/nvim ]; then
        PATH="/snap/bin:$PATH"
        export PATH
      fi
      install_tree_sitter
      ;;
    *)
      printf 'Unsupported operating system: %s\n' "$(uname -s)" >&2
      exit 1
      ;;
  esac
}

ensure_fd() {
  command -v fd >/dev/null 2>&1 && return

  if ! command -v fdfind >/dev/null 2>&1; then
    printf 'Neither fd nor fdfind is installed.\n' >&2
    exit 1
  fi

  local_bin="$home/.local/bin"
  mkdir -p "$local_bin"
  ln -sf "$(command -v fdfind)" "$local_bin/fd"
  printf 'Linked %s/fd to fdfind; ensure %s is on PATH.\n' "$local_bin" "$local_bin"
}

ensure_nvim_version() {
  version=$(nvim --version | awk 'NR == 1 { sub(/^NVIM v/, ""); sub(/[-+].*$/, ""); print; exit }')
  if ! version_at_least "$version" "$minimum_nvim_version"; then
    printf 'Neovim %s or newer is required; found %s.\n' "$minimum_nvim_version" "${version:-unknown}" >&2
    exit 1
  fi
}

link_config() {
  if [ -L "$config_target" ] && [ "$(readlink "$config_target")" = "$config_source" ]; then
    return
  fi

  mkdir -p "$config_dir"

  if [ -e "$config_target" ] || [ -L "$config_target" ]; then
    backup_dir=$(mktemp -d "${config_target}.backup.XXXXXX")
    mv "$config_target" "$backup_dir/"
    printf 'Backed up %s to %s\n' "$config_target" "$backup_dir"
  fi

  ln -s "$config_source" "$config_target"
  printf 'Linked %s to %s\n' "$config_target" "$config_source"
}

if [ "${NVIM_INSTALL_SKIP_PACKAGES:-0}" != 1 ]; then
  install_packages
fi

ensure_fd
ensure_nvim_version

[ -d "$config_source" ] || {
  printf 'Missing Neovim configuration at %s\n' "$config_source" >&2
  exit 1
}

link_config
