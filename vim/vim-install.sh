#!/user/bin/sh

# create symlink for vimrc.
echo -e "[*] create symlink for .vimrc"
ln -sf $(pwd)/vimrc.symlink ~/.vimrc

# create a symlink for the vim directory
echo -e "[*] create symlink for .vim directory"
ln -sf $(pwd)/vim.symlink ~/.vim

