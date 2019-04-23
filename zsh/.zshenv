# Path to your oh-my-zsh installation.
export ZSH=/Users/$(whoami)/.oh-my-zsh

export MANPATH="/usr/local/man:$MANPATH"

#Tmux plugin Autostart
export ZSH_TMUX_AUTOSTART=true

export BUNDLER_EDITOR='vim'

#load gcloud sdk
source ~/dotfiles/zsh/gcloud-config.sh

# load nvm
source ~/dotfiles/zsh/nvm-config.sh


# load rbenv
source ~/dotfiles/zsh/rbenv-config.sh

