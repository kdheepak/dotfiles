# brew install zplug

# source ~/.fonts/devicons-regular.sh
# source ~/.fonts/fontawesome-regular.sh
# source ~/.fonts/octicons-regular.sh
# source ~/.fonts/pomicons-regular.sh

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

POWERLEVEL9K_MODE='awesome-fontconfig'

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(dir vcs anaconda)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time background_jobs)
POWERLEVEL9K_TIME_BACKGROUND='none'
# gruvbox colors
ZSH_BG0="230" # fbf1c7
ZSH_BG1="223" # ebdbb2
ZSH_BG2="187" # d5c4a1
ZSH_BG3="144" # bdae93
ZSH_FG4="95"  # 7c6f64
ZSH_FG3="59"  # 665c54
ZSH_FG2="239" # 504945
ZSH_FG1="237" # 3c3836
ZSH_FG0="235" # 282828

POWERLEVEL9K_DIR_HOME_BACKGROUND="$ZSH_FG4"
POWERLEVEL9K_DIR_HOME_FOREGROUND="$ZSH_BG1"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_BACKGROUND="$ZSH_FG4"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="$ZSH_BG1"
POWERLEVEL9K_DIR_DEFAULT_BACKGROUND="$ZSH_FG4"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="$ZSH_BG1"

POWERLEVEL9K_VCS_CLEAN_BACKGROUND="$ZSH_BG1"
POWERLEVEL9K_VCS_CLEAN_FOREGROUND="$ZSH_FG4"
POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="$ZSH_BG1"
POWERLEVEL9K_VCS_UNTRACKED_FOREGROUND="$ZSH_FG4"
POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="$ZSH_BG1"
POWERLEVEL9K_VCS_MODIFIED_FOREGROUND="$ZSH_FG4"

POWERLEVEL9K_STATUS_BACKGROUND="$ZSH_BG1"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4
POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="$ZSH_BG1"
POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="$ZSH_FG4"
POWERLEVEL9K_STATUS_OK_FOREGROUND="$ZSH_FG4"
POWERLEVEL9K_STATUS_OK_BACKGROUND="$ZSH_BG1"
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

########################################################################
# vi-mode (based on oh-my-zsh plugin)
########################################################################

prompt_vi_mode() {
  case ${KEYMAP} in
    vicmd)
      "$1_prompt_segment" "$0_NORMAL" "$2" "$DEFAULT_COLOR" "default" "$POWERLEVEL9K_VI_COMMAND_MODE_STRING"
    ;;
    main|viins|*)
    ;;
  esac
}


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

source ~/.config/.aliases
source ~/.config/.exports
source ~/.bash_profile

# added by travis gem
[ -f /Users/$USER/.travis/travis.sh ] && source /Users/$USER/.travis/travis.sh
