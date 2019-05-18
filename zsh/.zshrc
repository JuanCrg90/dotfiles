source ~/dotfiles/zsh/powerlevel9k-config.sh
source ~/dotfiles/zsh/alias.sh
# Add wisely, as too many plugins slow down shell startup.
plugins=(bundler git heroku npm tmux)

# load nvm
source ~/dotfiles/zsh/nvm-config.sh

# load rbenv
source ~/dotfiles/zsh/rbenv-config.sh

source $ZSH/oh-my-zsh.sh
