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

zinit ice svn atpull'zinit creinstall -q .'; zinit snippet PZT::modules/git

zinit snippet PZT::modules/completion/init.zsh
zinit snippet PZT::modules/environment/init.zsh
zinit snippet PZT::modules/history/init.zsh
zinit snippet PZT::modules/python/init.zsh
zinit snippet PZT::modules/spectrum/init.zsh

zinit ice svn; zinit snippet PZT::modules/directory/init.zsh
zinit ice svn; zinit snippet PZT::modules/editor/init.zsh

# zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-history-substring-search
zinit light zdharma/history-search-multi-word

zinit ice wait'0' lucid; zinit load desyncr/auto-ls
zinit light djui/alias-tips
zinit light wfxr/forgit

zinit light nim-lang/nimble

zinit light frescoraja/powerlevel10k

zinit ice wait'1' lucid; zinit load hlissner/zsh-autopair

# sharkdp/bat
zinit ice wait lucid as'command' from'gh-r' mv'bat* -> bat' pick'bat/bat'
zinit light sharkdp/bat

# # ogham/exa, replacement for ls
# zinit ice wait lucid as'program' from'gh-r' mv'exa* -> exa'
# zinit light ogham/exa

# FZF
zinit ice wait lucid as'program' pick"$ZPFX/bin/(fzf|fzf-tmux)" \
    atclone"cp shell/completion.zsh _fzf_completion; \
      cp bin/(fzf|fzf-tmux) $ZPFX/bin; \
      PREFIX=$ZPFX ./install" \
    atload"source $HOME/.fzf.zsh"
zinit light junegunn/fzf

# diff-so-fancy
zinit ice wait lucid as'program' pick'bin/git-dsf'
zinit load zdharma/zsh-diff-so-fancy

# ripgrep
zinit ice from"gh-r" fbin"rg/rg" as"program" mv"ripgrep* -> rg" pick"rp/rg" bpick"${BPICK}"
zinit light BurntSushi/ripgrep

zinit ice has'git' wait'1' lucid fbin"bin/git-dsf"; zinit load zdharma/zsh-diff-so-fancy
zinit ice has'git' wait'1' lucid; zinit load wfxr/forgit
zinit ice has'git' wait'1' lucid; zinit load romkatv/gitstatus
# zinit ice wait"0" lucid; zinit load ael-code/zsh-colored-man-pages
zinit ice wait"0" pick"iterm2.plugin.zsh" lucid; zinit snippet OMZ::plugins/iterm2/iterm2.plugin.zsh

zinit snippet https://github.com/kdheepak/dotfiles/blob/master/.aliases
zinit snippet https://github.com/kdheepak/dotfiles/blob/master/.exports

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

#
# Key Bindings
#

if [[ -n "$key_info" ]]; then
  # Emacs
  bindkey -M emacs "$key_info[Control]P" history-substring-search-up
  bindkey -M emacs "$key_info[Control]N" history-substring-search-down

  # Vi
  bindkey -M vicmd "k" history-substring-search-up
  bindkey -M vicmd "j" history-substring-search-down

  # Emacs and Vi
  for keymap in 'emacs' 'viins'; do
    bindkey -M "$keymap" "$key_info[Up]" history-substring-search-up
    bindkey -M "$keymap" "$key_info[Down]" history-substring-search-down
  done

  unset keymap
fi

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

zinit light zsh-users/zsh-syntax-highlighting

