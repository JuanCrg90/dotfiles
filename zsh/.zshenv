# Path to your oh-my-zsh installation.
export ZSH=/Users/$(whoami)/.oh-my-zsh

export MANPATH="/usr/local/man:$MANPATH"

#Tmux plugin Autostart
export ZSH_TMUX_AUTOSTART=true

export EDITOR='nvim'
export BUNDLER_EDITOR='nvim'

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

export RUBY_CONFIGURE_OPTS="--with-openssl-dir=/opt/homebrew/opt/openssl@3"
export LDFLAGS="-L/opt/homebrew/opt/openssl@3/lib"
export CPPFLAGS="-I/opt/homebrew/opt/openssl@3/include"

export DISABLE_SPRING=true
export DB='postgres'
export LC_ALL=en_US.UTF-8

FILE=~/dotfiles/zsh/.private_vars
if [ -f "$FILE" ]; then
  source $FILE
fi
