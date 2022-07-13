# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
set -o emacs

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# brew install zplug

# source ~/.fonts/devicons-regular.sh
# source ~/.fonts/fontawesome-regular.sh
# source ~/.fonts/octicons-regular.sh
# source ~/.fonts/pomicons-regular.sh

source ~/gitrepos/dotfiles/aliases
source ~/gitrepos/dotfiles/exports

export PATH="$HOME/.local/bin:$PATH"

[ -f $HOME/.config/.custom ] && source $HOME/.config/.custom

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

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#d0d0d0"
export ZSH_AUTOSUGGEST_STRATEGY=(history)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1
setopt AUTO_CD
bindkey '^P' up-history
bindkey '^N' down-history

zstyle ':completion:*' menu select
_comp_options+=(globdots)  # include hidden files in autocomplete

zmodload zsh/zpty

zinit ice blockf atpull'zinit creinstall -q .'


zinit ice lucid wait \
        as:"program" \
        atclone:"./install --bin" \
        atpull:"%atclone" \
        pick:"bin/fzf" \
        multisrc:"shell/{key-bindings,completion}.zsh"
zinit load "junegunn/fzf"

zinit ice make as"command" mv"nnn -> nnn" pick"nnn"
zinit light jarun/nnn

zinit ice wait"2" lucid as"program" pick"bin/git-dsf"
zinit load zdharma-continuum/zsh-diff-so-fancy

zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat" atload"alias cat='bat'"
zinit load sharkdp/bat

zinit ice from"gh-r" as"program" mv"mdcat* -> mdcat" pick"mdcat/mdcat"
zinit load lunaryorn/mdcat

zinit ice from"gh-r" as"program" bpick"tig-*.tar.gz" atclone"cd tig-*/; ./configure; make" atpull"%atclone" pick"*/src/tig"
zinit light "jonas/tig"

zinit wait'1' lucid from"gh-r" as"program" light-mode for @high-moctane/nextword

hash tig &>/dev/null && zinit wait lucid for /zsh-tig-plugin

zinit ice from"gh-r" as"program" pick"so/so"
zinit load samtay/so

zinit ice from"gh-r" as"program" pick"pq-*/pq"
zinit load Th3Whit3Wolf/pquote

zinit ice from"gh-r" as"program"
zinit load extrawurst/gitui

zinit ice from"gh-r" as"program"
zinit load sayanarijit/xplr

fix-git-trim() {
  install_name_tool -change /usr/local/opt/openssl@1.1/lib/libssl.1.1.dylib $(brew --prefix)/opt/openssl@1.1/lib/libssl.1.1.dylib ~/.zinit/plugins/foriequal0---git-trim/git-trim/git-trim
  install_name_tool -change /usr/local/opt/openssl@1.1/lib/libcrypto.1.1.dylib $(brew --prefix)/opt/openssl@1.1/lib/libcrypto.1.1.dylib ~/.zinit/plugins/foriequal0---git-trim/git-trim/git-trim
}

zinit ice from"gh-r" as"program" pick"git-trim/git-trim"
zinit load foriequal0/git-trim

zinit ice lucid wait"0" as"program" from"gh-r" mv"lazygit* -> lazygit" atload"alias lg='lazygit'"
zinit load 'jesseduffield/lazygit'

zinit ice lucid wait"0" as"program" from"gh-r" mv"lazydocker* -> lazydocker"
zinit load 'jesseduffield/lazydocker'

zinit ice lucid wait"0" as"program" from"gh-r" mv"hadolint* -> hadolint"
zinit load 'hadolint/hadolint'

zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit load BurntSushi/ripgrep

zinit ice from"gh-r" as"program" mv"ripgrep_all* -> ripgrep_all" pick"ripgrep_all/rga"
zinit load phiresky/ripgrep-all

zinit ice depth'1' as"program" pick"ranger.py" atload"alias r='ranger.py'"
zinit load ranger/ranger

zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit load sharkdp/fd

zinit ice as"command" extract"" pick"delta/delta" mv"delta* -> delta" from"gh-r"
zinit load dandavison/delta

zinit ice lucid wait"0" as"program" from"gh-r" pick"gh*/bin/gh"
zinit load "cli/cli"

zinit ice lucid wait'0' as'program' id-as'rust-analyzer' from'gh-r' \
  ver'latest' mv'rust-analyzer* -> rust-analyzer'
zinit light rust-analyzer/rust-analyzer

# zi_completion has'pandoc'
zinit light srijanshetty/zsh-pandoc-completion

zinit ice wait:2 lucid extract"" from"gh-r" as"command" mv"exa* -> exa"
zinit load ogham/exa

zinit ice wait:2 lucid extract"" from"gh-r" as"command" mv"taskwarrior-tui* -> tt"
zinit load kdheepak/taskwarrior-tui

zinit load "b4b4r07/emoji-cli"

### starship
export STARSHIP_CONFIG=~/.config/starship.toml
zinit ice as"command" from"gh-r" \
      atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
      atpull"%atclone" src"init.zsh"
zinit light starship/starship

export NVM_SYMLINK_CURRENT=true
export NVM_AUTO_USE=true
zinit light lukechilds/zsh-nvm

zinit ice wait"0" pick"iterm2.plugin.zsh" lucid; zinit snippet OMZ::plugins/iterm2/iterm2.plugin.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/git.zsh
# zinit snippet PZT::modules/completion/init.zsh

zinit light zdharma-continuum/fast-syntax-highlighting

zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search

zinit ice wait"0" if'[[ -n "$commands[task]" ]]' lucid
zinit snippet OMZ::plugins/taskwarrior/taskwarrior.plugin.zsh

zinit snippet OMZ::plugins/brew/brew.plugin.zsh

bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

zinit ice depth=1 # optional, but avoids downloading the full history
zinit light 3v1n0/zsh-bash-completions-fallback
zinit wait lucid atload"zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

# hub: https://github.com/github/hub
zinit ice from"gh-r" as"program" mv"hub-*/bin/hub -> hub" atclone'./hub alias -s > zhook.zsh' atpull'%atclone'
zinit light github/hub
zinit ice silent as"completion" mv'hub.zsh_completion -> _hub'
zinit snippet https://raw.githubusercontent.com/github/hub/master/etc/hub.zsh_completion

# https://zdharma.org/zinit/wiki/Direnv-explanation/
zinit from"gh-r" as"program" mv"direnv* -> direnv" \
    atclone'./direnv hook zsh > zhook.zsh' atpull'%atclone' \
    pick"direnv" src="zhook.zsh" for \
        direnv/direnv

zinit load Aloxaf/fzf-tab

zinit load wfxr/forgit
export PATH="$PATH:$FORGIT_INSTALL_DIR/bin"

# zinit ice silent wait"0" pick"shell/*.zsh"
# zinit load "lotabout/skim"
#
# zinit ice from'gh-r' as'program' mv pick'bin/sk';
# zinit load lotabout/skim

zinit ice from'gh-r' as'program' mv'pastel* -> pastel' pick'pastel/pastel';
zinit load sharkdp/pastel

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

### End of Zinit's installer chunk

export PATH="$PATH:/Users/$USER/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

alias luamake=/Users/$USER/gitrepos/lua-language-server/3rd/luamake/luamake

[ -f "$HOME/.ghcup/env" ] && source "$HOME/.ghcup/env" # ghcup-env

autoload -U bashcompinit
bashcompinit
