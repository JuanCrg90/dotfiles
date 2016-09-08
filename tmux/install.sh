#!/usr/bin/sh

echo "[*] Installing tmux"
brew install tmux

echo "[*] download tmux-powrline plugin"
# https://github.com/erikw/tmux-powerline
git clone https://github.com/erikw/tmux-powerline.git

echo "[*] create symlink for my tmux-powerline theme"
rm $HOME/dotfiles/tmux/tmux-powerline/themes/default.sh
ln -sf $(pwd)/mytheme.symlink $HOME/dotfiles/tmux/tmux-powerline/themes/default.sh

echo "[*] create symlink for .tmux.conf"
ln -sf $(pwd)/tmux.symlink $HOME/.tmux.conf
