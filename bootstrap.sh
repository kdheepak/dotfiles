#!/usr/bin/env bash
echo "Symlinking files from $(pwd)"
mkdir -p ~/.config;
mkdir -p ~/.config/yapf;
mkdir -p ~/.config/nvim;
mkdir -p ~/.config/kak;
mkdir -p ~/.config/bat/bin;
mkdir -p ~/.config/alacritty;
mkdir -p ~/.julia/config;
mkdir -p ~/.hammerspoon;
rm ~/.config/yabai/yabairc; ln -s $(pwd)/yabairc ~/.config/yabai/yabairc
rm ~/.config/.exports; ln -s $(pwd)/.exports ~/.config/.exports
rm ~/.config/.aliases; ln -s $(pwd)/.aliases ~/.config/.aliases
rm ~/Library/ApplicationSupport/jesseduffield/lazygit/config.yml; ln -s $(pwd)/lazygit.yml ~/Library/ApplicationSupport/jesseduffield/lazygit/config.yml
rm ~/.tmux.conf; ln -s $(pwd)/.tmux.conf ~/.tmux.conf
rm ~/.tmux/status.conf; ln -s $(pwd)/status.conf ~/.tmux/status.conf
rm ~/.bash_profile; ln -s $(pwd)/.bash_profile ~/.bash_profile
rm ~/.zshenv; ln -s $(pwd)/.zshenv ~/.zshenv
rm ~/.zshrc; ln -s $(pwd)/.zshrc ~/.zshrc
rm ~/.p10k.zsh; ln -s $(pwd)/.p10k.zsh ~/.p10k.zsh
rm ~/.condarc; ln -s $(pwd)/.condarc ~/.condarc
rm ~/.config/yapf/style; ln -s $(pwd)/.yapf-style ~/.config/yapf/style
rm ~/.config/alacritty/alacritty.yml; ln -s $(pwd)/alacritty.yml ~/.config/alacritty/alacritty.yml
rm ~/.config/flake8; ln -s $(pwd)/.flake8 ~/.config/flake8
rm ~/.config/pycodestyle; ln -s $(pwd)/.pycodestyle ~/.config/pycodestyle
rm ~/.config/.fzf.bash; ln -s $(pwd)/.fzf.bash ~/.config/.fzf.bash
rm ~/.config/.fzf.zsh; ln -s $(pwd)/.fzf.zsh ~/.config/.fzf.zsh
rm -rf ~/.config/.tridactylrc; ln -s $(pwd)/..tridactylrc ~/.config/.tridactylrc
rm ~/.gdbinit; ln -s $(pwd)/.gdbinit ~/.gdbinit
rm ~/.gitignore; ln -s $(pwd)/.gitignore ~/.gitignore
rm ~/.gitconfig; ln -s $(pwd)/.gitconfig ~/.gitconfig
rm ~/.pylintrc; ln -s $(pwd)/.pylintrc ~/.pylintrc
rm ~/.julia/config/startup.jl; ln -s $(pwd)/.juliarc.jl ~/.julia/config/startup.jl
rm ~/.hammerspoon/init.lua; ln -s $(pwd)/.hammerspoon/init.lua ~/.hammerspoon/init.lua
rm -rf ~/.config/karabiner; ln -s $(pwd)/karabiner ~/.config/karabiner
rm -rf ~/.config/zathura; ln -s $(pwd)/zathura ~/.config/zathura
rm -rf ~/.config/kak; ln -s $(pwd)/kak ~/.config/kak
rm -rf ~/.config/bat/config; ln -s $(pwd)/batconfig ~/.config/bat/config
rm -rf ~/.config/bat/bin/preview_fzf_grep; ln -s $(pwd)/preview_fzf_grep ~/.config/bat/bin/preview_fzf_grep
rm -rf ~/.tmux/plugins/tpm; git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# tic -x xterm-256color-italic.terminfo
# tic -x tmux-256color.terminfo
