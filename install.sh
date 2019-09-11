#!/usr/bin/env bash
echo "Installing requirements"

brew install zplug
brew install exa
brew install ripgrep

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
