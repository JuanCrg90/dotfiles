# Environment needed by every zsh invocation. Keep interactive setup in .zshrc.

typeset -U path

[[ -d "$HOME/.local/bin" ]] && path=("$HOME/.local/bin" $path)
[[ -d "$HOME/.cargo/bin" ]] && path=("$HOME/.cargo/bin" $path)

export EDITOR=nvim
export BUNDLER_EDITOR="$EDITOR"
export DISABLE_SPRING=true

# Load private environment variables regardless of the current working directory.
private_vars="${${(%):-%N}:A:h}/.private_vars"
[[ -r "$private_vars" ]] && source "$private_vars"
unset private_vars
