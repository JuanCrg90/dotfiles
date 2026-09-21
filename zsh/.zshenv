# Environment needed by every zsh invocation. Keep interactive setup in .zshrc.

typeset -U path

[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/.cargo/bin" ]] && path=("$HOME/.cargo/bin" $path)

export EDITOR=nvim
export BUNDLER_EDITOR="$EDITOR"
export DISABLE_SPRING=true
export DB=postgres

() {
  local zsh_dotfiles_dir="${${(%):-%N}:A:h}"
  local private_vars="$zsh_dotfiles_dir/.private_vars"
  [[ -r "$private_vars" ]] && source "$private_vars"
}
