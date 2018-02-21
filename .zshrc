# brew install zplug

source ~/.fonts/devicons-regular.sh
source ~/.fonts/fontawesome-regular.sh
source ~/.fonts/octicons-regular.sh
source ~/.fonts/pomicons-regular.sh

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

POWERLEVEL9K_MODE='awesome-fontconfig'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv dir_writable vcs anaconda)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs history time)


zplug "modules/environment", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/history", from:prezto
zplug "modules/history-substring-search", from:prezto
zplug "modules/ssh", from:prezto
zplug "modules/git", from:prezto
zplug "modules/fasd", from:prezto
zplug "modules/tmux", from:prezto
zplug "modules/archive", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/spectrum", from:prezto
zplug "modules/utility", from:prezto
zplug "wbinglee/zsh-wakatime"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
zplug "srijanshetty/zsh-pip-completion"

zplug "plugins/z", from:oh-my-zsh

# zplug "plugins/brew-cask", from:oh-my-zsh
# zplug "plugins/brew", from:oh-my-zsh
# zplug "plugins/osx", from:oh-my-zsh
# zplug "plugins/xcode", from:oh-my-zsh

zplug "zdharma/fast-syntax-highlighting", defer:2

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
# zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

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
