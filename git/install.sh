#!/usr/bin/sh

# create symlink for .gitconfig
echo -e "create symlink for .gitconfig"
ln -sf $(pwd)/gitconfig.symlink ~/.gitconfig

# create symlink for .gitignore
echo -e "create symlink for .gitignore"
ln -sf $(pwd)/gitignore.symlink ~/.gitignore_global
