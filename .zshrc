# Check if zplug is installed
if [[ ! -d ~/.config/.zplug ]]; then
  git clone https://github.com/zplug/zplug ~/.config/.zplug
  source ~/.zplug/init.zsh && zplug update
fi

source ~/.zplug/init.zsh

#zplug "modules/environment", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/history", from:prezto
zplug "modules/history-substring-search", from:prezto
#zplug "modules/ssh", from:prezto
zplug "modules/git", from:prezto
#zplug "modules/fasd", from:prezto
#zplug "modules/tmux", from:prezto
#zplug "modules/archive", from:prezto
#zplug "modules/directory", from:prezto
#zplug "modules/terminal", from:prezto
#zplug "modules/editor", from:prezto
#zplug "modules/spectrum", from:prezto
#zplug "modules/utility", from:prezto
# zplug "chrissicool/zsh-256color"
# zplug "willghatch/zsh-saneopt"
# zplug "djui/alias-tips"
# zplug "supercrabtree/k"
# zplug "Tarrasch/zsh-bd"
# zplug "johnhamelink/env-zsh"
# zplug "joshuarubin/zsh-fzf"
# zplug "uvaes/fzf-marks"
# zplug "atweiden/fzf-extras"
# zplug "srijanshetty/zsh-suffix-alias"
# zplug "ascii-soup/zsh-url-highlighter"
# zplug "TBSliver/zsh-plugin-tmux-simple"
zplug "wbinglee/zsh-wakatime"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
# zplug "srijanshetty/zsh-pip-completion"
# zplug "vasyharan/zsh-brew-services"
#
zplug "plugins/z", from:oh-my-zsh

# zplug "plugins/brew-cask", from:oh-my-zsh
# zplug "plugins/brew", from:oh-my-zsh
# zplug "plugins/osx", from:oh-my-zsh
# zplug "plugins/xcode", from:oh-my-zsh

zplug "zdharma/fast-syntax-highlighting", defer:2
export POWERLEVEL9K_MODE='nerdfont-complete'
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
# zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# zplug "felixr/docker-zsh-completion"
# zplug "akoenig/gulp.plugin.zsh"
# zplug "DimitriSteyaert/Zsh-tugboat"
# zplug "edouard-lopez/yeoman-zsh-plugin"
# zplug "lukechilds/zsh-better-npm-completion"
# zplug "johnhamelink/rvm-zsh"
# zplug "lukechilds/zsh-nvm"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load


source ~/.config/.aliases
source ~/.config/.exports
source ~/.bash_profile


#zprof
