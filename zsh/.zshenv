# Path to your oh-my-zsh installation.
export ZSH=/Users/$(whoami)/.oh-my-zsh

export MANPATH="/usr/local/man:$MANPATH"

#Tmux plugin Autostart
export ZSH_TMUX_AUTOSTART=true

export EDITOR='vim'
export BUNDLER_EDITOR='vim'

export PATH="/usr/local/opt/protobuf@3.7/bin:$PATH"

# export LDFLAGS="-L/usr/local/opt/protobuf@3.7/lib"
# export CPPFLAGS="-I/usr/local/opt/protobuf@3.7/include"
export PKG_CONFIG_PATH="/usr/local/opt/protobuf@3.7/lib/pkgconfig"


 export LDFLAGS="-L/usr/local/opt/openssl/lib"
 export CPPFLAGS="-I/usr/local/opt/openssl/include"

# load nvm
# source ~/dotfiles/zsh/nvm-config.sh


# load rbenv
# source ~/dotfiles/zsh/rbenv-config.sh

# export DB='postgres'

# export DISABLE_YARN_INTEGRITY=true

export LC_ALL=en_US.UTF-8

export POWERLINE="$(python3 -m site --user-site)/powerline/bindings/vim/plugin/powerline.vim"
