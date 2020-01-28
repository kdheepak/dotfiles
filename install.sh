#!/usr/bin/env bash
echo "Installing requirements"

brew install neovim --HEAD
brew install zplug
brew install exa
brew install ripgrep
brew install bat

brew install coreutils binutils diffutils findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip watch wdiff wget gdb gpatch make git less openssh rsync unzip

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

pip install neovim
pip install pre-commit
