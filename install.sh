#!/usr/bin/env bash
echo "Installing requirements"

brew install neovim --HEAD
brew install zplug
brew install exa
brew install ripgrep
brew install bat

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

pip install neovim
pip install pre-commit
