#!/usr/bin/sh

echo "[*] Installing tmux"
brew install tmux reattach-to-user-namespace


echo "[*] download tmux-powrline plugin"
# https://github.com/erikw/tmux-powerline
git clone https://github.com/erikw/tmux-powerline.git

echo "[*] download tpm"
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo "[*] create symlink for my tmux-powerline theme"
rm $HOME/dotfiles/tmux/tmux-powerline/themes/default.sh
ln -sf $(pwd)/mytheme.symlink $HOME/dotfiles/tmux/tmux-powerline/themes/default.sh

echo "[*] create symlink for .tmux.conf"
ln -sf $(pwd)/tmux.symlink $HOME/.tmux.conf

echo "[*] Tmux installed, restart your terminal and run CTRL+A + I"
