#!/bin/sh

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
home=${HOME:?HOME must be set}

# ============================================================
# All-in-One Dotfiles Installer
# ============================================================
# Installs all dotfiles in dependency order:
#   mise → pi → codex → agy → herdr → nvim → zsh → git → gh → rtk → iterm
#
# Usage:
#   sh ~/dotfiles/install.sh              # Install all standard dotfiles
#   sh ~/dotfiles/install.sh --skip-nvim  # Skip Neovim
#   sh ~/dotfiles/install.sh --with-uhk   # Also install UHK config
#
# Available skips:
#   --skip-mise, --skip-herdr, --skip-nvim,
#   --skip-pi, --skip-codex, --skip-zsh, --skip-git, --skip-gh, --skip-rtk,
#   --skip-iterm
#
# UHK is opt-in because its configuration only applies when the keyboard is
# connected.
# ============================================================

SKIP_MISE=0
SKIP_PI=0
SKIP_CODEX=0
SKIP_AGY=0
SKIP_HERDR=0
SKIP_NVIM=0
SKIP_ZSH=0
SKIP_GIT=0
SKIP_GH=0
SKIP_RTK=0
SKIP_ITERM=0
INSTALL_UHK=0

parse_args() {
  for arg in "$@"; do
    case "$arg" in
      --skip-mise)  SKIP_MISE=1 ;;
      --skip-pi)    SKIP_PI=1 ;;
      --skip-codex) SKIP_CODEX=1 ;;
      --skip-agy)   SKIP_AGY=1 ;;
      --skip-herdr) SKIP_HERDR=1 ;;
      --skip-nvim)  SKIP_NVIM=1 ;;
      --skip-zsh)   SKIP_ZSH=1 ;;
      --skip-git)   SKIP_GIT=1 ;;
      --skip-gh)    SKIP_GH=1 ;;
      --skip-rtk)   SKIP_RTK=1 ;;
      --skip-iterm) SKIP_ITERM=1 ;;
      --with-uhk)   INSTALL_UHK=1 ;;
      --help|-h)
        printf '%s\n' "Usage: $0 [--skip-mise] [--skip-pi] [--skip-codex] [--skip-agy] [--skip-herdr] [--skip-nvim] [--skip-zsh] [--skip-git] [--skip-gh] [--skip-rtk] [--skip-iterm] [--with-uhk]"
        printf '%s\n' ""
        printf '%s\n' "All installers are idempotent — safe to run multiple times."
        exit 0
        ;;
      *)
        printf 'Unknown option: %s\n' "$arg" >&2
        printf 'Run %s --help for usage.\n' "$0" >&2
        exit 1
        ;;
    esac
  done
}

run_installer() {
  name=$1
  path=$2

  case "${name}" in
    mise)
      if [ "$SKIP_MISE" = 1 ]; then
        printf '%s\n' "[SKIP] mise"
        return
      fi
      ;;
    pi)
      if [ "$SKIP_PI" = 1 ]; then
        printf '%s\n' "[SKIP] pi"
        return
      fi
      ;;
    codex)
      if [ "$SKIP_CODEX" = 1 ]; then
        printf '%s\n' "[SKIP] codex"
        return
      fi
      ;;
    agy)
      if [ "$SKIP_AGY" = 1 ]; then
        printf '%s\n' "[SKIP] agy"
        return
      fi
      ;;
    herdr)
      if [ "$SKIP_HERDR" = 1 ]; then
        printf '%s\n' "[SKIP] herdr"
        return
      fi
      ;;
    nvim)
      if [ "$SKIP_NVIM" = 1 ]; then
        printf '%s\n' "[SKIP] nvim"
        return
      fi
      ;;
    zsh)
      if [ "$SKIP_ZSH" = 1 ]; then
        printf '%s\n' "[SKIP] zsh"
        return
      fi
      ;;
    git)
      if [ "$SKIP_GIT" = 1 ]; then
        printf '%s\n' "[SKIP] git"
        return
      fi
      ;;
    gh)
      if [ "$SKIP_GH" = 1 ]; then
        printf '%s\n' "[SKIP] gh"
        return
      fi
      ;;
    rtk)
      if [ "$SKIP_RTK" = 1 ]; then
        printf '%s\n' "[SKIP] rtk"
        return
      fi
      ;;
    iterm)
      if [ "$SKIP_ITERM" = 1 ]; then
        printf '%s\n' "[SKIP] iterm"
        return
      fi
      ;;
  esac

  installer="$path/install.sh"
  if [ ! -x "$installer" ]; then
    printf '%s\n' "[ERROR] Missing installer: $installer" >&2
    return 1
  fi

  printf '%s\n' "▶ Installing $name..."
  if sh "$installer"; then
    printf '%s\n' "✓ $name installed"
  else
    printf '%s\n' "✗ $name failed (see output above)" >&2
    if [ "$name" = zsh ]; then
      printf '%s\n' "  Existing Zsh files are left unchanged; move them aside manually to adopt this config." >&2
    fi
    return 1
  fi
  printf '\n'
}

install_iterm() {
  if [ "$SKIP_ITERM" = 1 ]; then
    printf '%s\n' "[SKIP] iterm"
    return
  fi

  iterm_dir="$script_dir/iterm"
  if [ "$(uname)" != "Darwin" ]; then
    printf '%s\n' "[SKIP] iterm (macOS only)"
    return
  fi

  profiles="$iterm_dir/Profiles.json"
  if [ ! -f "$profiles" ]; then
    printf '%s\n' "[ERROR] Missing $profiles" >&2
    return 1
  fi

  printf '%s\n' "▶ Importing iTerm2 profile..."
  printf '%s\n' "Open iTerm2 → Settings → Profiles → Import..."
  printf '%s\n' "Select: $profiles"
  printf '%s\n' "For the Monokai Tasty colorscheme:"
  printf '%s\n' "Open iTerm2 → Settings → Colors → Color Presets → Import..."
  printf '%s\n' "Select: $iterm_dir/monokai_tasty.itermcolors"
  printf '%s\n' "✓ iTerm2 profile imported"
  printf '\n'
}

main() {
  parse_args "$@"

  printf '%s\n' "========================================"
  printf '%s\n' "  Dotfiles Installer"
  printf '%s\n' "  $(date)"
  printf '%s\n' "========================================"
  printf '\n'

  errors=0

  # Dependency order: mise → pi → codex → agy → herdr → nvim → zsh → git → gh → rtk
  run_installer mise   "$script_dir/mise"   || errors=$((errors + 1))
  run_installer pi     "$script_dir/pi"     || errors=$((errors + 1))
  run_installer codex  "$script_dir/codex"  || errors=$((errors + 1))
  run_installer agy    "$script_dir/agy"    || errors=$((errors + 1))
  run_installer herdr  "$script_dir/herdr"  || errors=$((errors + 1))
  run_installer nvim  "$script_dir/nvim"  || errors=$((errors + 1))
  run_installer zsh   "$script_dir/zsh"   || errors=$((errors + 1))
  run_installer git   "$script_dir/git"   || errors=$((errors + 1))
  run_installer gh    "$script_dir/gh"    || errors=$((errors + 1))
  run_installer rtk   "$script_dir/rtk"   || errors=$((errors + 1))

  # Platform-specific installers
  install_iterm || errors=$((errors + 1))

  if [ "$INSTALL_UHK" = 1 ]; then
    run_installer uhk "$script_dir/uhk" || errors=$((errors + 1))
  else
    printf '%s\n' "[SKIP] uhk (use --with-uhk)"
  fi

  printf '%s\n' "========================================"
  if [ "$errors" -gt 0 ]; then
    printf '%s\n' "  Done with $errors error(s)" >&2
    exit 1
  else
    printf '%s\n' "  All installs complete"
  fi
  printf '%s\n' "========================================"
}

main "$@"
