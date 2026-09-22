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
├── install.sh         # All-in-one personal-machine installer
├── tests/             # POSIX shell regression tests
├── git/               # Git configuration (config symlinks + gitignore)
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

Use `sh ~/.dotfiles/install.sh --help` to list component skip flags. The
installer continues with independent components and returns a non-zero status
if any component fails.

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

This script automates the complete homelab setup in this order:

1. **NVIDIA drivers + CUDA toolkit** (optional: `HOMELAB_SKIP_NVIDIA=1`)
2. **System tools** (build-essential, git, cmake, curl, wget, ffmpeg, nvtop, htop, openssh-server, tailscale, fwupd, zsh)
3. **ML/AI tools** (Ollama, llama.cpp with CUDA, Hugging Face CLI, llama-swap)
4. **Docker** (via snap)
5. **Dotfiles** (mise → Pi → Codex → Herdr → Neovim → Zsh → Git → GitHub CLI → rtk)

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

#### Remote Clipboard

Local Neovim uses its native system clipboard provider. In SSH sessions and
Linux Herdr panes, remote yanks use Neovim's built-in OSC 52 copy callback, so
they reach the clipboard of the terminal running on the local machine. This
requires a local terminal emulator that supports OSC 52 clipboard writes and
permits terminal applications to access the clipboard.

Remote `p` deliberately uses Neovim's internal register, avoiding an OSC 52
clipboard-read query that may time out through the Herdr bridge. To paste from
the local system clipboard into a remote pane, use the terminal's normal paste
shortcut (for example, <kbd>Cmd</kbd>+<kbd>V</kbd> in iTerm2).

Verify the write path from a remote Herdr pane before relying on it:

```sh
printf '\033]52;c;%s\a' "$(printf 'OSC 52 clipboard test' | base64 | tr -d '\n')"
```

Paste into a local application. If it contains `OSC 52 clipboard test`, the
terminal, Herdr remote bridge, and local clipboard path are working.

### Mise

**macOS:** Installed via Homebrew (`brew install mise`).

**Pop!_OS Linux:** Installed via Snap (`sudo snap install mise --classic`).

Mise manages Node.js and pnpm. pnpm is pinned to 11.9.0 because the current
Mise `npm:pnpm` shim cannot execute pnpm 12's shell launcher. Neovim uses that
same pinned pnpm version to install `tree-sitter-cli` on Linux.

Zsh adds the platform-specific directory reported by `pnpm bin --global`, so
user-installed Node CLIs work on macOS and Pop!_OS without local shell
overrides. Use global pnpm packages only for machine-level CLIs and update them
explicitly with `pnpm update --global`; keep project dependencies local and run
them with `pnpm exec` or project scripts.

### Pi (primary AI development harness)

Installs with the [official Pi installer](https://pi.dev/install.sh) using
mise-managed `node@latest`, satisfying Pi's Node.js and npm requirement
without a system Node.js installation. A new managed installation is exposed at
`~/.local/bin/pi` and stores its managed files in `~/.pi/agent/`. The wrapper
also accepts an already executable `pi` elsewhere on `PATH`, such as a prior
pnpm global installation. Run `pi` and use `/login` to authenticate.

### Codex (secondary AI development harness)

Installs with the [official Codex installer](https://chatgpt.com/codex/install.sh)
to `~/.local/bin/codex`. The wrapper keeps `~/.local/bin` on `PATH`, so the
official installer does not modify the tracked Zsh profile; `zsh/.zshenv`
already adds that directory. Run `codex` to authenticate.

### Zsh

Requires `zsh`, `git`, and `mise` to be installed first (checked at runtime).
Clones Oh My Zsh and Powerlevel10k, then symlinks `.zshrc` and `.zshenv`.
Existing files or symlinks that point elsewhere are never overwritten: move
them aside manually before rerunning the installer. Put machine-specific shell
customizations in `~/.zsh.local`, which is sourced after mise activation.

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

### Neovim Plugin Lock

`nvim/nvim/lazy-lock.json` is the shared source of truth for plugin commits.
On regular machines, pull the repository and use `:Lazy sync`; do not run
`:Lazy update`. Update plugins only on a designated maintenance machine, test
the result, then commit and push the lockfile. Lazy's update checker only
checks for updates and does not modify the lockfile.

## Validation

Run the installer regressions after changing shell scripts:

```sh
sh tests/installers.sh
sh tests/zsh.sh
```

## Safety Features

All installers include:

- **Idempotency:** Safe to run multiple times
- **Config preservation:** Neovim and Herdr back up replaced configs; Zsh refuses to replace existing files or foreign symlinks
- **Symlink validation:** Refuses to overwrite symlinks that point elsewhere
- **Version checks:** Neovim requires ≥0.11.2
- **POSIX compliance:** Scripts use `#!/bin/sh` for maximum compatibility

## Notes

- `.pi/` directory is untracked (Pi project-local artifacts); `pi/` is the tracked installer directory
- All symlinks use script-relative paths for portability
- `lazy-lock.json` in `nvim/nvim/` is tracked in git to pin plugin versions across devices
