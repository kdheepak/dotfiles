#!/usr/bin/env bash
echo "Symlinking files from $(pwd)"
mkdir -p ~/.config;
mkdir -p ~/.config/yapf;
mkdir -p ~/.config/nvim;
mkdir -p ~/.config/kak;
mkdir -p ~/.config/alacritty;
mkdir -p ~/.julia/config;
mkdir -p ~/.hammerspoon;
rm ~/.config/nvim/init.vim; ln -s $(pwd)/.vimrc ~/.config/nvim/init.vim
rm ~/.config/.exports; ln -s $(pwd)/.exports ~/.config/.exports
rm ~/.config/.aliases; ln -s $(pwd)/.aliases ~/.config/.aliases
rm ~/.tmux.conf; ln -s $(pwd)/.tmux.conf ~/.tmux.conf
rm ~/.bash_profile; ln -s $(pwd)/.bash_profile ~/.bash_profile
rm ~/.zshenv; ln -s $(pwd)/.zshenv ~/.zshenv
rm ~/.zshrc; ln -s $(pwd)/.zshrc ~/.zshrc
rm ~/.condarc; ln -s $(pwd)/.condarc ~/.condarc
rm ~/.config/yapf/style; ln -s $(pwd)/.yapf-style ~/.config/yapf/style
rm ~/.config/alacritty/alacritty.yml; ln -s $(pwd)/alacritty.yml ~/.config/alacritty/alacritty.yml
rm ~/.config/flake8; ln -s $(pwd)/.flake8 ~/.config/flake8
rm ~/.config/pycodestyle; ln -s $(pwd)/.pycodestyle ~/.config/pycodestyle
rm ~/.config/.fzf.bash; ln -s $(pwd)/.fzf.bash ~/.config/.fzf.bash
rm ~/.config/.fzf.zsh; ln -s $(pwd)/.fzf.zsh ~/.config/.fzf.zsh
rm ~/.gdbinit; ln -s $(pwd)/.gdbinit ~/.gdbinit
rm ~/.gitignore; ln -s $(pwd)/.gitignore ~/.gitignore
rm ~/.pylintrc; ln -s $(pwd)/.pylintrc ~/.pylintrc
rm ~/.julia/config/startup.jl; ln -s $(pwd)/.juliarc.jl ~/.julia/config/startup.jl
rm ~/.hammerspoon/init.lua; ln -s $(pwd)/.hammerspoon/init.lua ~/.hammerspoon/init.lua
rm -rf ~/.config/karabiner; ln -s $(pwd)/karabiner ~/.config/karabiner
rm -rf ~/.config/zathura; ln -s $(pwd)/zathura ~/.config/zathura
rm -rf ~/.config/kak; ln -s $(pwd)/kak ~/.config/kak

echo "Setting up terminfo"
tic -x xterm-256color-italic.terminfo
tic -x tmux-256color.terminfo
