# Interactive shell configuration.

typeset -g ZSH_DOTFILES_DIR="${${(%):-%N}:A:h}"
typeset -g ZSH="${ZSH:-$HOME/.oh-my-zsh}"

source "$ZSH_DOTFILES_DIR/powerlevel10k-config.zsh"
source "$ZSH_DOTFILES_DIR/alias.sh"
[[ -r "$ZSH_DOTFILES_DIR/config/darwin.zsh" && "$OSTYPE" == darwin* ]] && source "$ZSH_DOTFILES_DIR/config/darwin.zsh"

# Add wisely, as too many plugins slow down shell startup.
plugins=(bundler git)
[[ -r "$ZSH/oh-my-zsh.sh" ]] && source "$ZSH/oh-my-zsh.sh"

if (( $+commands[mise] )); then
  eval "$(mise activate zsh)"
fi

# pnpm v11 installs global binaries in a platform-specific bin directory.
# Resolve it after mise activates the managed pnpm executable.
if (( $+commands[pnpm] )); then
  pnpm_global_bin="$(pnpm bin --global 2>/dev/null)" || pnpm_global_bin=
  [[ -d "$pnpm_global_bin" ]] && path=("$pnpm_global_bin" $path)
  unset pnpm_global_bin
fi

[[ -r "$HOME/.zsh.local" ]] && source "$HOME/.zsh.local"
