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

[[ -r "$HOME/.zsh.local" ]] && source "$HOME/.zsh.local"
