# Path to your oh-my-zsh installation.
export ZSH=/Users/$(whoami)/.oh-my-zsh

export MANPATH="/usr/local/man:$MANPATH"

#Tmux plugin Autostart
export ZSH_TMUX_AUTOSTART=true

export EDITOR='lvim'
export BUNDLER_EDITOR='lvim'

export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/protobuf@3.7/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin/:$PATH"
export PATH=/Users/$(whoami)/.local/bin:$PATH
export PATH=/bin:/usr/local/opt/rabbitmq/sbin:$PATH
export PATH=/Users/$(whoami)/Library/Python/3.9/bin:$PATH

JAVA8=/usr/local/opt/openjdk@8
if [ -d "$JAVA8" ]; then
  export PATH="/usr/local/opt/openjdk@8/bin:$PATH"
  export CPPFLAGS="-I/usr/local/opt/openjdk@8/include"
fi

GO_LANG=/usr/local/bin/go
if [ -f "$GO_LANG" ]; then
  export GOPATH=$HOME/go
  export GOROOT="$(brew --prefix golang)/libexec"
  export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
fi

export LDFLAGS="-L/usr/local/opt/openssl/lib"
export CPPFLAGS="-I/usr/local/opt/openssl/include"

export DISABLE_SPRING=true
export DB='postgres'
export LC_ALL=en_US.UTF-8

FILE=~/dotfiles/zsh/.private_vars
if [ -f "$FILE" ]; then
  source $FILE
fi
