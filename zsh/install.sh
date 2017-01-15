#!/usr/bin/sh

echo "install zsh"
brew install zsh zsh-completions

echo "set zsh as default shell"
sudo -s "echo /usr/local/bin/zsh >> /etc/shells" && chsh -s /usr/local/bin/zsh

echo "Install Oh-My-Zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"


echo "Install powerlevel9k Theme"
git clone https://github.com/bhilburn/powerlevel9k.git ~/.oh-my-zsh/custom/themes/powerlevel9k

echo "create symlink for .zshrc"
ln -sf $(pwd)/zshrc.symlink ~/.zshrc

