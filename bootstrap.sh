#!/usr/bin/env bash
echo "Symlinking files from $(pwd)"
mkdir -p ~/.config;
mkdir -p ~/.config/yapf;
mkdir -p ~/.config/nvim;
rm ~/.config/nvim/init.vim; ln -s $(pwd)/.vimrc ~/.config/nvim/init.vim
rm ~/.config/.exports; ln -s $(pwd)/.exports ~/.config/.exports
rm ~/.config/.aliases; ln -s $(pwd)/.aliases ~/.config/.aliases
rm ~/.tmux.conf; ln -s $(pwd)/.tmux.conf ~/.tmux.conf
rm ~/.bash_profile; ln -s $(pwd)/.bash_profile ~/.bash_profile
rm ~/.zshrc; ln -s $(pwd)/.zshrc ~/.zshrc
rm ~/.condarc; ln -s $(pwd)/.condarc ~/.condarc
rm ~/.config/yapf/style; ln -s $(pwd)/.yapf-style ~/.config/yapf/style
rm ~/.config/flake8; ln -s $(pwd)/.flake8 ~/.config/flake8
rm ~/.config/.fzf.bash; ln -s $(pwd)/.fzf.bash ~/.config/.fzf.bash
rm ~/.config/.fzf.zsh; ln -s $(pwd)/.fzf.zsh ~/.config/.fzf.zsh
rm ~/.gdbinit; ln -s $(pwd)/.gdbinit ~/.gdbinit
rm ~/.gitignore; ln -s $(pwd)/.gitignore ~/.gitignore
rm ~/.pylintrc; ln -s $(pwd)/.pylintrc ~/.pylintrc
