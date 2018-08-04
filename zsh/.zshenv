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

# brew link force # TODO Update this
# NOTE: I don't remember why I added this configuration, I will keep until I found what proyect require this link
# export PATH="/usr/local/opt/qt@5.5/bin:$PATH"
# export PATH="/usr/local/opt/imagemagick@6/bin:$PATH"
#
