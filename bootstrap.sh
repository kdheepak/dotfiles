#!/usr/bin/env bash
echo "Symlinking files from $(pwd)"
ln -s $(pwd)/.vimrc ~/.config/nvim/init.vim
ln -s $(pwd)/.exports ~/.config/.exports
ln -s $(pwd)/.aliases ~/.config/.aliases
ln -s $(pwd)/.tmux.conf ~/.tmux.conf
ln -s $(pwd)/.bash_profile ~/.bash_profile
ln -s $(pwd)/.zshrc ~/.zshrc
