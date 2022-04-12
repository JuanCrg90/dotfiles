#!/usr/bin/sh

echo "install zsh completions"
brew install zsh-completions

echo "Install Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Install powerlevel9k Theme"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

echo "create symlink for .zshrc"
ln -sf $(pwd)/.zshrc ~/.zshrc

echo "create symlink for .zshenv"
ln -sf $(pwd)/.zshenv ~/.zshenv
