# brew install zplug

# source ~/.fonts/devicons-regular.sh
# source ~/.fonts/fontawesome-regular.sh
# source ~/.fonts/octicons-regular.sh
# source ~/.fonts/pomicons-regular.sh

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

POWERLEVEL9K_MODE='awesome-fontconfig'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs anaconda)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status vi_mode command_execution_time background_jobs)
POWERLEVEL9K_TIME_BACKGROUND='none'
# gruvbox colors
# GB_BG0="fbf1c7" # "230"
# GB_BG1="ebdbb2" # "223"
# GB_BG2="d5c4a1" # "187"
# GB_BG3="bdae93" # "144"
# GB_FG4="7c6f64" # "95"
# GB_FG3="665c54" # "59"
# GB_FG2="504945" # "239"
# GB_FG1="3c3836" # "237"
# GB_FG0="282828" # "235"
# GB_RED="cc241d" # "160"
# GB_YELLOW="fabd2f" # "214"

POWERLEVEL9K_DIR_HOME_BACKGROUND="$GB_FG4"
POWERLEVEL9K_DIR_HOME_FOREGROUND="$GB_BG1"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$GB_FG4"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$GB_BG1"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$GB_FG4"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$GB_BG1"

POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$GB_BG1"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$GB_FG4"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$GB_BG1"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$GB_FG4"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$GB_BG1"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$GB_FG4"

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4

POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$GB_BG1"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$GB_FG4"

POWERLEVEL9K_STATUS_OK_FOREGROUND="$GB_FG4"
POWERLEVEL9K_STATUS_ERROR_BACKGROUND="$GB_RED"
POWERLEVEL9K_STATUS_ERROR_FOREGROUND="$GB_YELLOW"
POWERLEVEL9K_STATUS_OK_BACKGROUND="$GB_BG1"

POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_PROMPT_ADD_NEWLINE=true

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

zplug "plugins/vi-mode", from:oh-my-zsh

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

source ~/.config/.exports
source ~/.profile

clear
