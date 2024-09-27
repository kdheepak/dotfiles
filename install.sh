#!/usr/bin/env bash
echo "Installing requirements"

brew install neovim --HEAD
brew install exa
brew install ripgrep
brew install bat
brew install cmake
brew install tmux
brew install pkg-config

brew install koekeishiya/formulae/yabai
brew install koekeishiya/formulae/skhd

brew tap homebrew/cask-fonts
brew cask install font-hasklig-nerd-font
brew cask install font-firacode-nerd-font

brew install coreutils binutils diffutils findutils gawk gnu-indent gnu-sed gnu-tar gnu-which gnutls grep gzip watch wdiff wget gdb gpatch make git less openssh rsync unzip

git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell
