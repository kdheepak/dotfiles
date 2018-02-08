#!/usr/bin/env bash
echo "Symlinking files from $(pwd)"
ln -s $(pwd)/.vimrc ~/.config/nvim/init.vim
ln -s $(pwd)/.exports ~/.config/.exports
ln -s $(pwd)/.aliases ~/.config/.aliases
ln -s $(pwd)/.tmux.conf ~/.tmux.conf
ln -s $(pwd)/.bash_profile ~/.bash_profile
ln -s $(pwd)/.zshrc ~/.zshrc
ln -s $(pwd)/.condarc ~/.condarc
ln -s $(pwd)/.yapf/style ~/.config/yapf/style
ln -s $(pwd)/.flake8 ~/.config/flake8
ln -s $(pwd)/.fzf.bash ~/.config/.fzf.bash
ln -s $(pwd)/.fzf.zsh ~/.config/.fzf.zsh
ln -s $(pwd)/.gdbinit ~/.gdbinit
ln -s $(pwd)/.gitignore ~/.gitignore
ln -s $(pwd)/.pylintrc ~/.pylintrc
