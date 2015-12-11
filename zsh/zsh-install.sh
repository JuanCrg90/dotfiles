#!/usr/bin/sh

# create symlink for .gitconfig
echo -e "create symlink for .zshrc"
ln -sf $(pwd)/zshrc.symlink ~/.zshrc

# create symlink for .gitconfig
echo -e "create symlink for .zprofile"
ln -sf $(pwd)/zprofile.symlink ~/.zprofile


