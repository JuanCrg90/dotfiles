#!/usr/bin/sh

# create symlink for .zshrc
echo -e "create symlink for .zshrc"
ln -sf $(pwd)/zshrc.symlink ~/.zshrc

