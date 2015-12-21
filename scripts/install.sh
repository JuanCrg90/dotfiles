#! /usr/bin/sh

#Creating the local scripts directory
mkdir -p ~/.local/bin
#Copy the ovpn script to /bin
ln -sf $(pwd)/ovpnConnect.symlink ~/.local/bin/ovpnConnect
