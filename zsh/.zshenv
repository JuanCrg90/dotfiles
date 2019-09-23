# Path to your oh-my-zsh installation.
export ZSH=/Users/$(whoami)/.oh-my-zsh

export MANPATH="/usr/local/man:$MANPATH"

#Tmux plugin Autostart
export ZSH_TMUX_AUTOSTART=true

export EDITOR='vim'
export BUNDLER_EDITOR='vim'

# load nvm
# source ~/dotfiles/zsh/nvm-config.sh


# load rbenv
# source ~/dotfiles/zsh/rbenv-config.sh

export DB='postgres'

export DISABLE_YARN_INTEGRITY=true

export POWERLINE="$(python3 -m site --user-site)/powerline/bindings/vim/plugins/powerline.vim"
