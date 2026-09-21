alias zshconfig='nvim "$ZSH_DOTFILES_DIR"'
alias la='ls -al'
alias :q='exit'
alias gapan='git add --intent-to-add . && git add --patch'

alias be='bundle exec'
alias ber='bundle exec rails'
alias bert='bundle exec rails test'

if [[ "$OSTYPE" == darwin* ]] && (( $+commands[brew] )); then
  alias bubc='brew upgrade && brew cleanup'
fi

if (( $+commands[nvim] )); then
  alias vim='nvim'
fi

commiter_script="$HOME/Projects/agent-scripts/scripts/commiter"
[[ -x "$commiter_script" ]] && alias commiter="$commiter_script"
unset commiter_script
