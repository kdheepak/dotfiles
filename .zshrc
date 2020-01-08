# brew install zplug

# source ~/.fonts/devicons-regular.sh
# source ~/.fonts/fontawesome-regular.sh
# source ~/.fonts/octicons-regular.sh
# source ~/.fonts/pomicons-regular.sh

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

POWERLEVEL9K_MODE='nerdfont-complete'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs anaconda)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time vi_mode background_jobs)

POWERLEVEL9K_TIME_BACKGROUND='none'
POWERLEVEL9K_COLOR_SCHEME='dark'

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

A_FG='#f0f0f0'
A_BG='#50a14f'
B_FG='#494b53'
B_BG='#d3d3d3'
C_FG='#494b53'
C_BG='#f0f0f0'

# DIR
# General Directory Settings
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND=$A_FG
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND=$A_BG

# Home Folder Settings
POWERLEVEL9K_DIR_HOME_FOREGROUND=$A_FG
POWERLEVEL9K_DIR_HOME_BACKGROUND=$A_BG

# Home Subfolder Settings
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND=$A_FG
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND=$A_BG

# Etc Directory Settings
POWERLEVEL9K_DIR_ETC_FOREGROUND=$A_FG
POWERLEVEL9K_DIR_ETC_BACKGROUND=$A_BG

# VCS
POWERLEVEL9K_VCS_CLEAN_FOREGROUND=$B_FG
POWERLEVEL9K_VCS_CLEAN_BACKGROUND=$B_BG
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND=$B_FG
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=$B_BG
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND=$B_FG
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=$B_BG
POWERLEVEL9K_VCS_CLOBBERED_FOREGROUND=$B_FG
POWERLEVEL9K_VCS_CLOBBERED_BACKGROUND=$B_BG

# Anaconda
POWERLEVEL9K_ANACONDA_FOREGROUND=$C_FG
POWERLEVEL9K_ANACONDA_BACKGROUND=$C_BG

# Status
POWERLEVEL9K_STATUS_OK_FOREGROUND=$C_FG
POWERLEVEL9K_STATUS_OK_BACKGROUND=$C_BG
POWERLEVEL9K_STATUS_ERROR_FOREGROUND=$A_FG
POWERLEVEL9K_STATUS_ERROR_BACKGROUND='#dd5f1c'

# Command execution time
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND=$B_FG
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND=$B_BG

# Vi mode
# VI Mode Normal
POWERLEVEL9K_VI_MODE_NORMAL_FOREGROUND=$A_FG
POWERLEVEL9K_VI_MODE_NORMAL_BACKGROUND=$A_BG

# VI Mode Insert
POWERLEVEL9K_VI_MODE_INSERT_FOREGROUND=$A_FG
POWERLEVEL9K_VI_MODE_INSERT_BACKGROUND='#447bef'

zplug 'zplug/zplug', hook-build:'zplug --self-manage'

zplug "modules/environment", from:prezto
zplug "modules/terminal", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/directory", from:prezto
zplug "modules/spectrum", from:prezto
# zplug "modules/utility", from:prezto
zplug "modules/completion", from:prezto
# zplug "modules/prompt", from:prezto
zplug "modules/git", from:prezto

zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting"

zplug "junegunn/fzf", use:"shell/{completion.zsh,key-bindings.zsh}"
zplug "rupa/z", use:z.sh
zplug "andrewferrier/fzf-z", on:"rupa/z"

# zplug "plugins/vi-mode", from:oh-my-zsh

zplug "srijanshetty/zsh-pip-completion"
zplug "zdharma/fast-syntax-highlighting", defer:2
# zplug "zsh-users/zsh-syntax-highlighting", defer:2

zplug "mollifier/cd-gitroot"

zplug "hlissner/zsh-autopair", defer:2

# zplug "plugins/osx", from:oh-my-zsh
# zplug "plugins/xcode", from:oh-my-zsh

# zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
zplug "romkatv/powerlevel10k", use:powerlevel10k.zsh-theme
# Async for zsh, used by pure
# zplug "laurenkt/zsh-vimto"
# zplug "mafredri/zsh-async", from:github, defer:0
# zplug "sindresorhus/pure", use:pure.zsh, from:github, as:theme

zplug "nim-lang/nimble"

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
  zplug install
fi

# Then, source plugins and add commands to $PATH
zplug load

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

function zle-keymap-select zle-line-init
{
    # change cursor shape in iTerm2
    case $KEYMAP in
        vicmd)      echo -ne '\e[1 q';; # block cursor
        viins|main) echo -ne '\e[5 q';;
    esac

    zle reset-prompt
    zle -R
}

function zle-line-finish
{
    echo -ne '\e[1 q' # block cursor
}

zle -N zle-line-init
zle -N zle-line-finish
zle -N zle-keymap-select

fpath=(/usr/local/share/zsh-completions $fpath)

disable r

source $HOME/.config/.exports
source $HOME/.config/.aliases
[ -f $HOME/.config/.custom ] && source $HOME/.config/.custom

# clear

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export ZSH_AUTOSUGGEST_USE_ASYNC=true

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
