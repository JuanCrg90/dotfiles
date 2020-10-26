# Path to your oh-my-zsh installation.
export ZSH=/Users/$(whoami)/.oh-my-zsh

export MANPATH="/usr/local/man:$MANPATH"

#Tmux plugin Autostart
export ZSH_TMUX_AUTOSTART=true

export EDITOR='vim'
export BUNDLER_EDITOR='vim'

export PATH="$PATH:/usr/local/opt/protobuf@3.7/bin:/Applications/Postgres.app/Contents/Versions/latest/bin/:/Users/juancarlosruiz/Library/Android/sdk/:/Users/juancarlosruiz/Library/Android/sdk/emulator:/Users/juancarlosruiz/Library/Android/sdk/platform-tools/"

export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

# export DB='postgres'

export LC_ALL=en_US.UTF-8

export POWERLINE="$(python3 -m site --user-site)/powerline/bindings/vim/plugin/powerline.vim"
