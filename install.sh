#!/usr/bin/env bash
echo "Installing requirements"

brew install neovim --HEAD
brew install exa
brew install ripgrep
brew install bat
brew install cmake
brew install tmux

brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

brew tap homebrew/cask-fonts
brew cask install font-hasklig-nerd-font
brew cask install font-firacode-nerd-font

brew install coreutils binutils diffutils findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip watch wdiff wget gdb gpatch make git less openssh rsync unzip

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell

wget https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh -O miniconda.sh && bash miniconda.sh -b -p $HOME/miniconda3 -f -u

pip install neovim
pip install pre-commit
