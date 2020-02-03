# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# brew install zplug

# source ~/.fonts/devicons-regular.sh
# source ~/.fonts/fontawesome-regular.sh
# source ~/.fonts/octicons-regular.sh
# source ~/.fonts/pomicons-regular.sh

export PATH="$HOME/.local/bin:$PATH"

source $HOME/.config/.exports
source $HOME/.config/.aliases
[ -f $HOME/.config/.custom ] && source $HOME/.config/.custom

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi

source "$HOME/.zinit/bin/zinit.zsh"

zinit light zsh-users/zsh-autosuggestions
zinit light zdharma/history-search-multi-word
zinit light frescoraja/powerlevel10k
zinit light djui/alias-tips
zinit light wfxr/forgit

zinit ice wait"0" pick"iterm2.plugin.zsh" lucid
zinit snippet OMZ::plugins/iterm2/iterm2.plugin.zsh

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

### End of Zinit installer's chunk

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS+=anaconda
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time vi_mode background_jobs)

POWERLEVEL9K_TIME_BACKGROUND='none'
POWERLEVEL9K_COLOR_SCHEME='dark'

POWERLEVEL9K_SHORTEN_DIR_LENGTH=1
POWERLEVEL9K_SHORTEN_DELIMITER=""
POWERLEVEL9K_SHORTEN_STRATEGY="truncate_from_right"

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4

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

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#d0d0d0"
