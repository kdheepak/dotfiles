# brew install zplug

source ~/.config/.aliases
source ~/.config/.exports
source ~/.bash_profile

source ~/.fonts/devicons-regular.sh
source ~/.fonts/fontawesome-regular.sh
source ~/.fonts/octicons-regular.sh
source ~/.fonts/pomicons-regular.sh

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

POWERLEVEL9K_MODE='awesome-fontconfig'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir rbenv dir_writable vcs anaconda)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs history time)

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "modules/history", from:prezto
zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/git", from:prezto

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"
zplug "rupa/z", use:z.sh
zplug "andrewferrier/fzf-z", on:"rupa/z"
zplug "junegunn/fzf", as:plugin, use:'shell/completion.zsh'
zplug "junegunn/fzf", as:plugin, use:'shell/key-bindings.zsh'

zplug "srijanshetty/zsh-pip-completion"
zplug "zdharma/fast-syntax-highlighting", defer:2

# zplug "plugins/brew-cask", from:oh-my-zsh
# zplug "plugins/brew", from:oh-my-zsh
# zplug "plugins/osx", from:oh-my-zsh
# zplug "plugins/xcode", from:oh-my-zsh

zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
# zplug "zsh-users/zsh-syntax-highlighting", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#zprof
