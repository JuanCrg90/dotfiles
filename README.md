# My Dotfiles

Personal configuration repository for development environments across macOS and Pop!_OS Linux devices.

## Purpose

This repository manages dotfiles and configuration scripts for:

- **Personal development machines** (2× macOS, 2× Pop!_OS Linux)
- **Homelab server** (Pop!_OS with NVIDIA/CUDA workloads)

All installers are idempotent, cross-platform where applicable, and follow POSIX `sh` compliance for maximum compatibility.

## Directory Structure

```
dotfiles/
├── git/              # Git configuration (config symlinks + gitignore)
├── zsh/              # Zsh + Oh My Zsh + Powerlevel10k theme
├── nvim/             # Neovim configuration + installer
├── herdr/            # Herdr terminal multiplexer config
├── mise/             # mise environment manager installer
├── iterm/            # iTerm2 portable profile + Monokai theme
├── uhk/              # Ultimate Hacking Keyboard config
├── homelab/          # Homelab recovery script (NVIDIA, Ollama, Docker, etc.)
└── README.md         # This file
```

## Quick Installation

### Personal Machines

Run the following commands on each machine to install all dotfiles:

```bash
# Clone this repository first
git clone git@github.com:JuanCrg90/dotfiles.git ~/.dotfiles

# 1. Install mise (environment manager)
sh ~/.dotfiles/mise/install.sh

# 2. Install Neovim + plugins
sh ~/.dotfiles/nvim/install.sh

# 3. Install Zsh + Oh My Zsh
sh ~/.dotfiles/zsh/install.sh

# 4. Install Git config
sh ~/.dotfiles/git/install.sh

# 5. Install Herdr
sh ~/.dotfiles/herdr/install.sh

# 6. Install iTerm2 profile (macOS only)
# Copy iterm/Profiles.json to your iTerm2 preferences via:
# iTerm2 → Settings → Profiles → Import
```

**Note:** Run `mise/install.sh` before `nvim/install.sh` — Neovim on Linux requires `tree-sitter-cli` managed by mise.

### Homelab Server

For a fresh Pop!_OS homelab installation, run the unified recovery script:

```bash
git clone git@github.com:JuanCrg90/dotfiles.git ~/.dotfiles
sh ~/.dotfiles/homelab/install.sh
```

This script automates the complete homelab setup:

1. **NVIDIA drivers + CUDA toolkit** (optional: skip with `HOMELAB_SKIP_NVIDIA=1`)
2. **System tools** (build-essential, git, cmake, curl, wget, ffmpeg, nvtop, htop, openssh-server, tailscale, fwupd, zsh)
3. **Dotfiles** (mise → herdr → nvim → zsh → git)
4. **ML/AI tools** (Ollama, llama.cpp with CUDA, Hugging Face CLI, llama-swap)
5. **Docker** (via snap)

Each step is independently skippable via `HOMELAB_SKIP_*` environment variables. See the script source for all available skip options.

## Platform Support

| Directory | macOS | Pop!_OS Linux |
|-----------|-------|---------------|
| `git/` | ✅ | ✅ |
| `zsh/` | ✅ | ✅ |
| `nvim/` | ✅ (Homebrew) | ✅ (Snap + APT + pnpm) |
| `herdr/` | ✅ (Homebrew) | ✅ (official installer) |
| `mise/` | ✅ (Homebrew) | ✅ (Snap) |
| `iterm/` | ✅ | ❌ (macOS only) |
| `uhk/` | ✅ | ✅ |
| `homelab/` | ❌ | ✅ (Pop!_OS only) |

## Installation Details

### Neovim

**macOS:** Installs via Homebrew (`brew install neovim ripgrep fd tree-sitter`).

**Pop!_OS Linux:** Installs Neovim via Snap, dependencies via APT, and `tree-sitter-cli` via user-local pnpm (managed by mise).

The `tree-sitter` binary is required by Neovim's native LSP and language support. On Pop!_OS, it's installed via mise → pnpm since Snap/APT don't provide `tree-sitter-cli`.

### Mise

**macOS:** Installed via Homebrew (`brew install mise`).

**Pop!_OS Linux:** Installed via Snap (`sudo snap install mise --classic`).

Mise manages `pnpm` globally, which is used by Neovim on Linux for `tree-sitter-cli`.

### Zsh

Requires `zsh`, `git`, and `mise` to be installed first (checked at runtime). Clones Oh My Zsh and Powerlevel10k theme, then symlinks `.zshrc` and `.zshenv`.

### Git

Symlinks `gitconfig` and `.gitignore_global`. Does not install `git` itself — assumes it's already available.

### Herdr

**macOS:** Installs via Homebrew (`brew install herdr`) or official installer as fallback.

**Pop!_OS Linux:** Installs via official installer (`curl -fsSL https://herdr.dev/install.sh | sh`).

Symlinks `~/.config/herdr/config.toml` from the repo.

### iTerm2

Exports a portable `Default` profile excluding machine-specific settings (working directories, bound hosts, sessions). Import manually via iTerm2 preferences.

## Safety Features

All installers include:

- **Idempotency:** Safe to run multiple times
- **Safe backups:** Existing configs are backed up before being replaced
- **Symlink validation:** Refuses to overwrite existing symlinks pointing elsewhere
- **Version checks:** Neovim requires ≥0.11.2
- **POSIX compliance:** Scripts use `#!/bin/sh` for maximum compatibility

## Notes

- `.pi/` directory is untracked (agent artifacts)
- All symlinks use script-relative paths for portability
- `lazy-lock.json` in `nvim/nvim/` is tracked in git to pin plugin versions across devices
