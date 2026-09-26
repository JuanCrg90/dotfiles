#!/bin/sh

set -eu

script_dir=$(CDPATH= cd "$(dirname "$0")" && pwd)
home=${HOME:?HOME must be set}

# ============================================================
# Homelab Recovery Script
# ============================================================
# This script automates the full homelab setup from the
# reinstallation checklist. It installs homelab-specific
# packages first, then delegates to existing dotfiles
# installers for the personal dev environment.
# ============================================================

# ============================================================
# 1. System Package Manager
# ============================================================
ensure_package_manager() {
  command -v apt-get >/dev/null 2>&1 || {
    printf 'Error: apt-get not found. This script requires Pop!_OS/Ubuntu.\n' >&2
    exit 1
  }
}

# ============================================================
# 2. NVIDIA Drivers + CUDA Toolkit
# ============================================================
install_nvidia() {
  if [ "${HOMELAB_SKIP_NVIDIA:-0}" = 1 ]; then
    printf '%s\n' "Skipping NVIDIA setup (HOMELAB_SKIP_NVIDIA=1)"
    return
  fi

  printf '%s\n' "Installing NVIDIA drivers + CUDA toolkit..."
  sudo apt-get update
  sudo apt-get install -y nvidia-driver-580-open nvidia-dkms-580-open nvidia-settings nvidia-cuda-toolkit

  printf '%s\n' "NVIDIA drivers installed. Reboot may be required."
}

# ============================================================
# 3. Core System Tools
# ============================================================
install_system_tools() {
  if [ "${HOMELAB_SKIP_SYSTEM_TOOLS:-0}" = 1 ]; then
    printf '%s\n' "Skipping system tools (HOMELAB_SKIP_SYSTEM_TOOLS=1)"
    return
  fi

  printf '%s\n' "Installing core system tools..."
  sudo apt-get update
  sudo apt-get install -y build-essential git cmake curl wget ffmpeg nvtop htop openssh-server tailscale fwupd zsh
}

# ============================================================
# 4. Dotfiles: mise (prerequisite for everything else)
# ============================================================
install_mise() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    printf '%s\n' "Skipping dotfiles installers (HOMELAB_SKIP_DOTFILES=1)"
    return
  fi

  mise_dir="$script_dir/../mise"
  if [ -d "$mise_dir" ] && [ -x "$mise_dir/install.sh" ]; then
    printf '%s\n' "Running mise/install.sh..."
    sh "$mise_dir/install.sh"
  elif command -v mise >/dev/null 2>&1; then
    printf '%s\n' "mise already installed: $(command -v mise)"
  else
    printf '%s\n' "Warning: mise/install.sh not found and mise not installed."
  fi
}

# ============================================================
# 5. Dotfiles: Pi (primary AI development harness)
# ============================================================
install_pi() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  pi_dir="$script_dir/../pi"
  if [ -d "$pi_dir" ] && [ -x "$pi_dir/install.sh" ]; then
    printf '%s\n' "Running pi/install.sh..."
    sh "$pi_dir/install.sh"
  elif [ -x "$home/.local/bin/pi" ]; then
    printf '%s\n' "Pi already installed: $home/.local/bin/pi"
  else
    printf '%s\n' "Warning: pi/install.sh not found and Pi not installed."
  fi
}

# ============================================================
# 6. Dotfiles: Codex (secondary AI development harness)
# ============================================================
install_codex() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  codex_dir="$script_dir/../codex"
  if [ -d "$codex_dir" ] && [ -x "$codex_dir/install.sh" ]; then
    printf '%s\n' "Running codex/install.sh..."
    sh "$codex_dir/install.sh"
  elif [ -x "$home/.local/bin/codex" ]; then
    printf '%s\n' "Codex already installed: $home/.local/bin/codex"
  else
    printf '%s\n' "Warning: codex/install.sh not found and Codex not installed."
  fi
}

# ============================================================
# 7. Dotfiles: agy (Antigravity CLI)
# ============================================================
install_agy() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  agy_dir="$script_dir/../agy"
  if [ -d "$agy_dir" ] && [ -x "$agy_dir/install.sh" ]; then
    printf '%s\n' "Running agy/install.sh..."
    sh "$agy_dir/install.sh"
  elif [ -x "$home/.local/bin/agy" ]; then
    printf '%s\n' "agy already installed: $home/.local/bin/agy"
  else
    printf '%s\n' "Warning: agy/install.sh not found and agy not installed."
  fi
}

# ============================================================
# 8. Dotfiles: herdr
# ============================================================
install_herdr() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  herdr_dir="$script_dir/../herdr"
  if [ -d "$herdr_dir" ] && [ -x "$herdr_dir/install.sh" ]; then
    printf '%s\n' "Running herdr/install.sh..."
    sh "$herdr_dir/install.sh"
  elif command -v herdr >/dev/null 2>&1; then
    printf '%s\n' "herdr already installed: $(command -v herdr)"
  else
    printf '%s\n' "Warning: herdr/install.sh not found and herdr not installed."
  fi
}

# ============================================================
# 9. Dotfiles: nvim (requires mise + apt packages)
# ============================================================
install_nvim() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  nvim_dir="$script_dir/../nvim"
  if [ -d "$nvim_dir" ] && [ -x "$nvim_dir/install.sh" ]; then
    printf '%s\n' "Running nvim/install.sh..."
    sh "$nvim_dir/install.sh"
  elif command -v nvim >/dev/null 2>&1; then
    printf '%s\n' "nvim already installed: $(nvim --version | head -1)"
  else
    printf '%s\n' "Warning: nvim/install.sh not found and nvim not installed."
  fi
}

# ============================================================
# 10. Dotfiles: zsh (requires zsh + git + mise)
# ============================================================
install_zsh() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  zsh_dir="$script_dir/../zsh"
  if [ -d "$zsh_dir" ] && [ -x "$zsh_dir/install.sh" ]; then
    printf '%s\n' "Running zsh/install.sh..."
    sh "$zsh_dir/install.sh"
  elif command -v zsh >/dev/null 2>&1; then
    printf '%s\n' "zsh already installed: $(zsh --version)"
  else
    printf '%s\n' "Warning: zsh/install.sh not found and zsh not installed."
  fi
}

# ============================================================
# 11. Dotfiles: git (config symlinks only)
# ============================================================
install_git() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  git_dir="$script_dir/../git"
  if [ -d "$git_dir" ] && [ -x "$git_dir/install.sh" ]; then
    printf '%s\n' "Running git/install.sh..."
    sh "$git_dir/install.sh"
  elif command -v git >/dev/null 2>&1; then
    printf '%s\n' "git already installed: $(git --version)"
  else
    printf '%s\n' "Warning: git/install.sh not found and git not installed."
  fi
}

# ============================================================
# 12. Dotfiles: GitHub CLI
# ============================================================
install_gh() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  gh_dir="$script_dir/../gh"
  if [ -d "$gh_dir" ] && [ -x "$gh_dir/install.sh" ]; then
    printf '%s\n' "Running gh/install.sh..."
    sh "$gh_dir/install.sh"
  elif command -v gh >/dev/null 2>&1 || [ -x /snap/bin/gh ]; then
    printf '%s\n' "GitHub CLI already installed"
  else
    printf '%s\n' "Warning: gh/install.sh not found and GitHub CLI not installed."
  fi
}

# ============================================================
# 13. Dotfiles: rtk
# ============================================================
install_rtk() {
  if [ "${HOMELAB_SKIP_DOTFILES:-0}" = 1 ]; then
    return
  fi

  rtk_dir="$script_dir/../rtk"
  if [ -d "$rtk_dir" ] && [ -x "$rtk_dir/install.sh" ]; then
    printf '%s\n' "Running rtk/install.sh..."
    sh "$rtk_dir/install.sh"
  elif [ -x "$home/.local/bin/rtk" ]; then
    printf '%s\n' "rtk already installed: $home/.local/bin/rtk"
  else
    printf '%s\n' "Warning: rtk/install.sh not found and rtk not installed."
  fi
}

# ============================================================
# 14. Ollama
# ============================================================
install_ollama() {
  if [ "${HOMELAB_SKIP_OLLAMA:-0}" = 1 ]; then
    printf '%s\n' "Skipping ollama (HOMELAB_SKIP_OLLAMA=1)"
    return
  fi

  if command -v ollama >/dev/null 2>&1; then
    printf '%s\n' "ollama already installed: $(ollama --version 2>/dev/null || echo "unknown")"
    return
  fi

  printf '%s\n' "Installing ollama..."
  curl -fsSL https://ollama.com/install.sh | sh
}

# ============================================================
# 15. llama.cpp (CUDA build)
# ============================================================
install_llama_cpp() {
  if [ "${HOMELAB_SKIP_LLAMA_CPP:-0}" = 1 ]; then
    printf '%s\n' "Skipping llama.cpp (HOMELAB_SKIP_LLAMA_CPP=1)"
    return
  fi

  llama_dir="$home/llama.cpp"
  if [ -d "$llama_dir/.git" ]; then
    printf '%s\n' "llama.cpp already cloned at $llama_dir"
    return
  fi

  printf '%s\n' "Cloning and building llama.cpp (CUDA)..."
  mkdir -p "$home"
  cd "$home"
  git clone https://github.com/ggml-org/llama.cpp
  cd llama.cpp
  mkdir build
  cd build
  cmake .. -DGGML_CUDA=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_CUDA_ARCHITECTURES="86"
  cmake --build . --config Release -j$(nproc)
}

# ============================================================
# 16. Hugging Face CLI
# ============================================================
install_hf_cli() {
  if [ "${HOMELAB_SKIP_HF_CLI:-0}" = 1 ]; then
    printf '%s\n' "Skipping Hugging Face CLI (HOMELAB_SKIP_HF_CLI=1)"
    return
  fi

  if command -v huggingface-cli >/dev/null 2>&1; then
    printf '%s\n' "Hugging Face CLI already installed"
    return
  fi

  printf '%s\n' "Installing Hugging Face CLI..."
  curl -LsSf https://hf.co/cli/install.sh | bash
}

# ============================================================
# 17. llama-swap
# ============================================================
install_llama_swap() {
  if [ "${HOMELAB_SKIP_LLAMA_SWAP:-0}" = 1 ]; then
    printf '%s\n' "Skipping llama-swap (HOMELAB_SKIP_LLAMA_SWAP=1)"
    return
  fi

  llama_swap_bin="$home/llama-swap/bin/llama-swap"
  if [ -x "$llama_swap_bin" ]; then
    printf '%s\n' "llama-swap already installed at $llama_swap_bin"
    return
  fi

  printf '%s\n' "Installing llama-swap..."
  mkdir -p "$home/llama-swap/bin"
  wget -q https://github.com/mostlygeek/llama-swap/releases/latest/download/llama-swap_linux_amd64.tar.gz
  tar xzf llama-swap_linux_amd64.tar.gz -C "$home/llama-swap/bin/"
  rm -f llama-swap_linux_amd64.tar.gz
}

# ============================================================
# 18. Docker (snap)
# ============================================================
install_docker() {
  if [ "${HOMELAB_SKIP_DOCKER:-0}" = 1 ]; then
    printf '%s\n' "Skipping Docker (HOMELAB_SKIP_DOCKER=1)"
    return
  fi

  if command -v docker >/dev/null 2>&1; then
    printf '%s\n' "Docker already installed: $(docker --version 2>/dev/null || echo "unknown")"
    return
  fi

  if ! command -v snap >/dev/null 2>&1; then
    printf '%s\n' "Warning: snap not found; skipping Docker installation."
    return
  fi

  printf '%s\n' "Installing Docker via snap..."
  sudo snap install docker
}

# ============================================================
# Main Execution
# ============================================================
main() {
  printf '%s\n' "========================================"
  printf '%s\n' "  Homelab Recovery Script"
  printf '%s\n' "  $(date)"
  printf '%s\n' "========================================"
  printf '%s\n' ""

  ensure_package_manager

  # Homelab-specific packages (order: system → ML tools)
  install_nvidia
  install_system_tools
  install_ollama
  install_llama_cpp
  install_hf_cli
  install_llama_swap
  install_docker

  # Dotfiles (order: mise → pi → codex → agy → herdr → nvim → zsh → git → gh → rtk)
  install_mise
  install_pi
  install_codex
  install_agy
  install_herdr
  install_nvim
  install_zsh
  install_git
  install_gh
  install_rtk

  printf '%s\n' ""
  printf '%s\n' "========================================"
  printf '%s\n' "  Homelab Setup Complete"
  printf '%s\n' "========================================"
  printf '%s\n' ""
  printf '%s\n' "Optional: restart or reboot if NVIDIA drivers were installed."
  printf '%s\n' "Optional: run 'tailscale up' to join your tailnet."
}

main "$@"
