# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.

eval "$($HOME/homebrew/bin/brew shellenv)"

set -o emacs

has() {
  type "$1" > /dev/null 2>&1
}

source ~/gitrepos/dotfiles/base16.fzf.config

# practically unlimited history

export HISTFILE=$HOME/.zsh_history
export HISTSIZE=999999999
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST
unsetopt autocd

# brew install zplug

# source ~/.fonts/devicons-regular.sh
# source ~/.fonts/fontawesome-regular.sh
# source ~/.fonts/octicons-regular.sh
# source ~/.fonts/pomicons-regular.sh

[ -f $HOME/.config/.custom ] && source $HOME/.config/.custom
source ~/gitrepos/dotfiles/aliases
source ~/gitrepos/dotfiles/exports

# Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma-continuum/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f" || \
        print -P "%F{160}▓▒░ The clone has failed.%f"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer

# zinit ice depth=1; zinit light romkatv/powerlevel10k

# # To customize prompt, run `p10k configure` or edit ~/gitrepos/dotfiles/p10k.zsh.
# [[ ! -f ~/gitrepos/dotfiles/p10k.zsh ]] || source ~/gitrepos/dotfiles/p10k.zsh

# export POWERLEVEL9K_DIR_HYPERLINK=true
#
# export POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
# export POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4
#
# # cyan reads better
# export POWERLEVEL9K_DIR_BACKGROUND='#89b4fa'
# export POWERLEVEL9K_DIR_FOREGROUND='#11111b'
# export POWERLEVEL9K_DIR_ANCHOR_FOREGROUND='#11111b'
# export POWERLEVEL9K_DIR_SHORTENED_FOREGROUND='#11111b'
# export POWERLEVEL9K_SHOW_CHANGESET=true
# export POWERLEVEL9K_CHANGESET_HASH_LENGTH=6
#
# export POWERLEVEL9K_VCS_CLEAN_BACKGROUND=4
# export POWERLEVEL9K_VCS_MODIFIED_BACKGROUND=5
# export POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND=4
# export POWERLEVEL9K_VCS_CONFLICTED_BACKGROUND=5
# export POWERLEVEL9K_VCS_LOADING_BACKGROUND=8
#
# export POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
#     # =========================[ Line #1 ]=========================
#     # os_icon                 # os identifier
#     dir                     # current directory
#     vcs                     # git status
#     # =========================[ Line #2 ]=========================
#     newline                 # \n
#     # prompt_char           # prompt symbol
# )

setopt AUTO_CD
bindkey '^P' up-history
bindkey '^N' down-history

_comp_options+=(globdots)  # include hidden files in autocomplete

zmodload zsh/zpty

zinit ice blockf atpull'zinit creinstall -q .'

zinit ice lucid as"program" pick"bin/git-dsf"
zinit load zdharma-continuum/zsh-diff-so-fancy

zinit load "b4b4r07/emoji-cli"

export NVM_SYMLINK_CURRENT=true
export NVM_AUTO_USE=true
zinit light lukechilds/zsh-nvm

# zinit ice pick"iterm2.plugin.zsh" lucid; zinit snippet OMZ::plugins/iterm2/iterm2.plugin.zsh
# zinit snippet OMZ::plugins/git/git.plugin.zsh
# zinit snippet OMZ::lib/history.zsh
# zinit snippet OMZ::lib/completion.zsh
# zinit snippet OMZ::lib/git.zsh

zinit light zdharma-continuum/fast-syntax-highlighting

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search

# zinit snippet OMZ::plugins/brew/brew.plugin.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

zinit ice depth=1 # optional, but avoids downloading the full history
zinit light 3v1n0/zsh-bash-completions-fallback
zinit lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

zinit load Aloxaf/fzf-tab

zinit load wfxr/forgit

zstyle ':fzf-tab:*' fzf-bindings 'ctrl-space:toggle+down' 'ctrl-y:yank'
zstyle ':completion:complete:*:options' sort false
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':fzf-tab:*' single-group ''
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':completion:*:descriptions' format ' %d'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:*' switch-group ',' '.'

zstyle ':completion:*' special-dirs true

# setup file preview - keep adding commands we might need preview for
local PREVIEW_SNIPPET='$HOME/gitrepos/dotfiles/fzf/preview-file $realpath'
local NO_PREVIEW_SNIPPET='$HOME/gitrepos/dotfiles/fzf/preview-file $realpath'
zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' fzf-preview 'eval echo \$$word'
zstyle ':fzf-tab:complete:*:*' fzf-preview $NO_PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:ln:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:ls:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:cd:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:z:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:zd:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:exa:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:v:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:nvim:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:vim:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:vi:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:c:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:cat:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:bat:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:rm:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:cp:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:mv:*' fzf-preview $PREVIEW_SNIPPET
zstyle ':fzf-tab:complete:rsync:*' fzf-preview $PREVIEW_SNIPPET

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview 'git diff $word | delta --syntax-theme=GitHub'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview 'git log --oneline --decorate --graph --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta --syntax-theme=GitHub;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta --syntax-theme=GitHub;;
	"recent commit object name") git show --color=always $word | delta --syntax-theme=GitHub;;
	*) git log --oneline --decorate --graph --color=always $word ;;
	esac'

zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

# Preview variables
# TODO: Only works with exported values as this is executed in a subshell. Is
#       there a way around this? I fear not...
zstyle ':fzf-tab:complete:-parameter-:*' fzf-preview 'typeset -p1 "$word"'

# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

autoload -U bashcompinit
bashcompinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

eval "$($HOME/.local/bin/mise activate zsh)"
export PATH="$HOME/.local/share/mise/shims:$PATH"
export PATH=$HOME/.pixi/bin:$PATH
export PATH=$HOME/.juliaup/bin:$PATH

eval "$(pixi completion --shell zsh)"

eval "$(starship init zsh)"

eval "$(direnv hook zsh)"

. "$HOME/.cargo/env"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$("$HOME/miniforge3/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/miniforge3/etc/profile.d/conda.sh" ]; then
        . "$HOME/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "$HOME/miniforge3/etc/profile.d/mamba.sh" ]; then
    . "$HOME/miniforge3/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

