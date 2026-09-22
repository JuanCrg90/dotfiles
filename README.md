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
├── gh/               # GitHub CLI installer
├── pi/               # Pi primary AI development harness installer
├── codex/            # Codex secondary AI development harness installer
├── rtk/              # rtk command-wrapper installer
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

Clone this repository, then run the all-in-one installer:

```bash
git clone git@github.com:JuanCrg90/dotfiles.git ~/.dotfiles
sh ~/.dotfiles/install.sh
```

It installs dependencies in this order: mise → Pi → Codex → Herdr → Neovim →
Zsh → Git → GitHub CLI → rtk. UHK remains opt-in (`--with-uhk`).

To run installers individually:

```bash
# 1. Install mise (environment manager)
sh ~/.dotfiles/mise/install.sh

# 2. Install Pi (primary AI development harness)
sh ~/.dotfiles/pi/install.sh

# 3. Install Codex (secondary AI development harness)
sh ~/.dotfiles/codex/install.sh

# 4. Install Neovim + plugins
sh ~/.dotfiles/nvim/install.sh

# 5. Install Zsh + Oh My Zsh
sh ~/.dotfiles/zsh/install.sh

# 6. Install Git config
sh ~/.dotfiles/git/install.sh

# 7. Install GitHub CLI
sh ~/.dotfiles/gh/install.sh

# 8. Install rtk
sh ~/.dotfiles/rtk/install.sh

# 9. Install Herdr
sh ~/.dotfiles/herdr/install.sh

# 10. Install iTerm2 profile (macOS only)
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
3. **Dotfiles** (mise → Pi → Codex → herdr → nvim → zsh → git → gh → rtk)
4. **ML/AI tools** (Ollama, llama.cpp with CUDA, Hugging Face CLI, llama-swap)
5. **Docker** (via snap)

Each step is independently skippable via `HOMELAB_SKIP_*` environment variables. See the script source for all available skip options.

## Platform Support

| Directory | macOS | Pop!_OS Linux |
|-----------|-------|---------------|
| `git/` | ✅ | ✅ |
| `gh/` | ✅ (Homebrew) | ✅ (Snap) |
| `pi/` | ✅ (official installer via mise Node.js) | ✅ (official installer via mise Node.js) |
| `codex/` | ✅ (official installer) | ✅ (official installer) |
| `rtk/` | ✅ (official installer) | ✅ (official installer) |
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

Mise manages pnpm 11.9.0 globally, which is used by Neovim on Linux for
`tree-sitter-cli`. Zsh adds the platform-specific global binary directory
reported by `pnpm bin --global`, so user-installed Node CLIs work on macOS and
Pop!_OS without local shell overrides.

### Pi (primary AI development harness)

Installs with the [official Pi installer](https://pi.dev/install.sh) using
mise-managed `node@latest`, satisfying Pi's Node.js and npm requirement
without a system Node.js installation. Pi is installed at `~/.local/bin/pi`
and stores its managed files in `~/.pi/agent/`. Run `pi` and use `/login` to
authenticate.

### Codex (secondary AI development harness)

Installs with the [official Codex installer](https://chatgpt.com/codex/install.sh)
to `~/.local/bin/codex`. The wrapper keeps `~/.local/bin` on `PATH`, so the
official installer does not modify the tracked Zsh profile; `zsh/.zshenv`
already adds that directory. Run `codex` to authenticate.

### Zsh

Requires `zsh`, `git`, and `mise` to be installed first (checked at runtime). Clones Oh My Zsh and Powerlevel10k theme, then symlinks `.zshrc` and `.zshenv`.

### Git

Symlinks `gitconfig` and `.gitignore_global`. Does not install `git` itself — assumes it's already available.

### GitHub CLI

**macOS:** Installed via Homebrew (`brew install gh`).

**Pop!_OS Linux:** Installed via Snap (`sudo snap install gh --classic`).

Use `gh auth login` after installation to authenticate each device.

### rtk

Installs via the official checksum-verified installer to `~/.local/bin/rtk`.

The tracked Zsh environment (`zsh/.zshenv`) prepends `~/.local/bin` whenever
it exists. Open a new Zsh session after installation to use `rtk`.

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

- `.pi/` directory is untracked (Pi project-local artifacts); `pi/` is the tracked installer directory
- All symlinks use script-relative paths for portability
- `lazy-lock.json` in `nvim/nvim/` is tracked in git to pin plugin versions across devices
