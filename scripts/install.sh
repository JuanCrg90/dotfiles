#! /usr/bin/sh

#Creating the local scripts directory
mkdir -p $HOME/.local/bin
#Copy the ovpn script to $HOME/.local/bin
ln -sf $(pwd)/ovpnConnect.symlink ~/.local/bin/ovpnConnect

#Copy the fixInotify script to $HOME/.local/bin
ln -sf $(pwd)/fixInotify.symlink ~/.local/bin/fixInotify

#Copy the updatePython script to $HOME/.local/bin
ln -sf $(pwd)/updatePython.symlink ~/.local/bin/updatePython
