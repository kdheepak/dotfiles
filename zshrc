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

# From https://github.com/bew/dotfiles/blob/1e1117fec1a043027a40e27434acf85d5fdeb00d/zsh/rc/mappings.zsh#L543

# Get the row (0-indexed) the cursor is on (in a multi-lines buffer)
function zle::utils::get-cursor-row0-in-buffer
{
  local cursor_row0_in_buffer=0
  for (( i=1; i<=$#LBUFFER; i++ )); do
    [[ ${LBUFFER[$i]} == $'\n' ]] && (( cursor_row0_in_buffer += 1 ))
  done
  REPLY_cursor_row0_in_buffer=$cursor_row0_in_buffer
}

function zle::term-utils::get-cursor-pos
{
  # Inspired from: https://www.zsh.org/mla/users/2015/msg00866.html
  # It seems to work well :) (unlike my own old impl from a long time ago)
  local pos="" char
  print -n $'\e[6n' # Ask terminal for cursor position
  # Then read char by char until we get a 'R'
  # (terminal reply looks like: `\e[57;12R`)
  while read -r -s -k1 char; do
    [[ $char == R ]] && break
    pos+=$char
  done
  pos=${pos#*\[} # remove '\e['

  # pos has format 'row;col'
  REPLY_cursor_row_in_term=${pos%;*} # remove ';col'
  REPLY_cursor_col_in_term=${pos#*;} # remove 'row;'
}

# NOTE: when implemented in terminals, we can have '...reveal-scrollback-by' !
function zle::term-utils::hide-scrollback-by
{
  local by_rows="${1:-1}" # default to 1 line
  [[ "$by_rows" == 0 ]] && return

  echo -n $'\e['"${by_rows}S" >/dev/tty # Scroll the terminal
  echo -n $'\e['"${by_rows}A" >/dev/tty # Move the cursor back up
}

# NOTE: Not perfect..
#   When completion menu is visible, it quits completion mode
#   (accepting current entry for some reason..)
function zwidget::clear-but-keep-scrollback
{
  local REPLY_cursor_row_in_term REPLY_cursor_col_in_term
  zle::term-utils::get-cursor-pos

  local REPLY_cursor_row0_in_buffer
  zle::utils::get-cursor-row0-in-buffer

  local prompt_row=$(( REPLY_cursor_row_in_term - REPLY_cursor_row0_in_buffer ))
  zle::term-utils::hide-scrollback-by "$(( prompt_row - 1 ))"

  zle redisplay
  # zle -M "prompt row was: $prompt_row"
}
zle -N zwidget::clear-but-keep-scrollback
bindkey '^l' zwidget::clear-but-keep-scrollback

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

zinit load wfxr/forgit

zinit load Aloxaf/fzf-tab

zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:complete:*:options' sort false
zstyle ':completion:*' special-dirs true

zstyle ':fzf-tab:*' fzf-bindings 'ctrl-space:toggle+down' 'ctrl-y:yank'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' switch-group '<' '>'

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
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'
zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
	'git diff $word | delta'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
	'git log --color=always $word'
zstyle ':fzf-tab:complete:git-help:*' fzf-preview \
	'git help $word | bat -plman --color=always'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
	'case "$group" in
	"commit tag") git show --color=always $word ;;
	*) git show --color=always $word | delta ;;
	esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
	'case "$group" in
	"modified file") git diff $word | delta ;;
	"recent commit object name") git show --color=always $word | delta ;;
	*) git log --color=always $word ;;
	esac'


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

export PATH=$HOME/.juliaup/bin:$PATH

if [[ "$TERM_PROGRAM" == "vscode" ]]; then
  eval "$($HOME/.local/bin/mise activate zsh --shims)"
else
  eval "$($HOME/.local/bin/mise activate zsh)"
fi

eval "$(pixi completion --shell zsh)"

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

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

path=('$HOME/.juliaup/bin' $path)
export PATH

# <<< juliaup initialize <<<

# >>> gams initialize >>>
# !! Contents within this block are managed by a gams installer script !!
export PATH="$HOME/.local/bin/gams_49_6_1/gams49.6_osx_arm64:$PATH"
# <<< gams initialize <<<

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export DENO_INSTALL="$HOME/.deno"
export PATH="$DENO_INSTALL/bin:$PATH"
eval "$(uv generate-shell-completion zsh)"

eval "$(starship init zsh)"

eval "$(direnv hook zsh)"


fpath+=~/.zfunc; autoload -Uz compinit; compinit

