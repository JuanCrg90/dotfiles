alias zshconfig='nvim "$ZSH_DOTFILES_DIR"'
alias la='ls -al'
alias :q='exit'
alias gapan='git add --intent-to-add . && git add --patch'

alias be='bundle exec'
alias ber='bundle exec rails'
alias bert='bundle exec rails test'

if [[ "$OSTYPE" == darwin* ]] && (($ + commands[brew])); then
  alias bubc='brew upgrade && brew cleanup'
fi

if (($ + commands[nvim])); then
  alias vim='nvim'
fi

committer_script="$HOME/Projects/agent-scripts/scripts/committer"
[[ -x "$committer_script" ]] && alias committer="$committer_script"
unset committer_script
