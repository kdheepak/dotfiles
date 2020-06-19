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

source ~/gitrepos/dotfiles/aliases
source ~/gitrepos/dotfiles/exports

export PATH="$HOME/.local/bin:$PATH"

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
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer

zinit ice depth=1; zinit load romkatv/powerlevel10k

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

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#d0d0d0"
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

zinit ice blockf atpull'zinit creinstall -q .'
zinit load zsh-users/zsh-completions

zinit load zsh-users/zsh-autosuggestions
zinit load zdharma/history-search-multi-word

zinit ice wait"0b" lucid atload'bindkey "$terminfo[kcuu1]" history-substring-search-up; bindkey "$terminfo[kcud1]" history-substring-search-down'
zinit load zsh-users/zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

zinit ice lucid wait \
        as:"program" \
        atclone:"./install --bin" \
        atpull:"%atclone" \
        pick:"bin/fzf" \
        multisrc:"shell/{key-bindings,completion}.zsh"
zinit load "junegunn/fzf"

zinit load Aloxaf/fzf-tab

zstyle ':fzf-tab:*' show-group full
zstyle ':fzf-tab:*' single-group full
zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' continuous-trigger 'alt-enter'
# Previews for some commands
local extract="
in=\${\${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
local -A ctxt=(\"\${(@ps:\2:)CTXT}\")
"
local sanitized_in='${~ctxt[hpre]}"${${in//\\ / }/#\~/$HOME}"'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:kill:argument-rest' extra-opts --preview=$extract'ps --pid=$in[(w)1] -o cmd --no-headers -w -w' --preview-window=down:3:wrap
zstyle ':fzf-tab:complete:*' extra-opts
zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always '$sanitized_in --preview-window=right:40%
zstyle ':fzf-tab:complete:exa:*' extra-opts --preview=$extract'exa -1 --color=always '$sanitized_in --preview-window=right:40%
zstyle ':fzf-tab:complete:nvim:*' extra-opts --preview=$extract'bat --pager=never --color=always --line-range :30 '$sanitized_in --preview-window=right:70%
zstyle ':fzf-tab:complete:vim:*' extra-opts --preview=$extract'bat --pager=never --color=always --line-range :30 '$sanitized_in --preview-window=right:70%

zinit ice wait"2" lucid as"program" pick"bin/git-dsf"
zinit load zdharma/zsh-diff-so-fancy

zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat" atload"alias cat='bat'"
zinit load sharkdp/bat

# zinit ice lucid wait from"gh-r" as"program" pick"./*/*/nvim"
# zinit load neovim/neovim

zinit ice lucid wait"0" as"program" from"gh-r" mv"lazygit* -> lazygit" atload"alias lg='lazygit'"
zinit load 'jesseduffield/lazygit'

zinit ice lucid wait"0" as"program" from"gh-r" mv"lazydocker* -> lazydocker" atload"alias lg='lazydocker'"
zinit load 'jesseduffield/lazydocker'

zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit load BurntSushi/ripgrep

zinit ice depth'1' as"program" pick"ranger.py" atload"alias r='ranger.py'"
zinit load ranger/ranger

zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit load sharkdp/fd

zinit ice lucid wait"0" as"program" from"gh-r" pick"gh*/bin/gh"
zinit load "cli/cli"

zinit ice wait:2 lucid extract"" from"gh-r" as"command" mv"exa* -> exa"
zinit load ogham/exa
zinit load DarrinTisdale/zsh-aliases-exa

zinit load "b4b4r07/emoji-cli"

zinit ice wait"0" pick"iterm2.plugin.zsh" lucid; zinit snippet OMZ::plugins/iterm2/iterm2.plugin.zsh
zinit snippet PZT::modules/completion/init.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh

zinit ice wait'!0' lucid; zinit load "hlissner/zsh-autopair"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
### End of Zinit's installer chunk
