#!/user/bin/sh

RED='\033[0;31m'
NC='\033[0m' # No Color]]'

echo "[*] Install neovim"
brew install neovim

echo "[*] Create nvim config directory"
mkdir -p ~/.config/nvim

echo "[*] Create symlink for .vimrc"
ln -sf $(pwd)/init.vim ~/.config/nvim/init.vim

# create a symlink for the vim directory
echo "[*] Create symlink for .vim directory"
ln -sf $(pwd)/vim.symlink ~/.vim

echo "[*] Create swap files directory"
mkdir ~/.tmp

echo "[*] Download Plug"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

echo "[*] Done. please enter to vim and run ${RED}:PlugInstall${NC}"


