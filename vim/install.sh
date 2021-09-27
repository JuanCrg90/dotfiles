#!/user/bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color]]'

echo "[*] Install vim"
brew install vim

echo "[*] Create symlink for .vimrc"
ln -sf $(pwd)/vimrc.symlink ~/.vimrc

# create a symlink for the vim directory
echo "[*] Create symlink for .vim directory"
ln -sf $(pwd)/vim.symlink ~/.vim

echo "[*] Create swap files directory"
mkdir ~/.tmp

echo "[*] Download python powerline"
pip3 install --user powerline-status

echo "[*] Download Plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "[*] Done. please enter to vim and run ${RED}:PlugInstall${NC}"


