#!/usr/bin/sh

# create symlink for .tmux.conf
echo -e "[*] create symlink for .tmux.conf"
ln -sf $(pwd)/tmux.symlink ~/.tmux.conf


