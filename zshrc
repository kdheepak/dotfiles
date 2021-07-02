# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
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

POWERLEVEL9K_DIR_HYPERLINK=true
POWERLEVEL9K_TRANSIENT_PROMPT=off

POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=4

export ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#d0d0d0"
export ZSH_AUTOSUGGEST_STRATEGY=(history)
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
export ZSH_AUTOSUGGEST_USE_ASYNC=1
export ZSH_AUTOSUGGEST_MANUAL_REBIND=1

zmodload zsh/zpty

zinit ice blockf atpull'zinit creinstall -q .'

zinit ice lucid wait \
        as:"program" \
        atclone:"./install --bin" \
        atpull:"%atclone" \
        pick:"bin/fzf" \
        multisrc:"shell/{key-bindings,completion}.zsh"
zinit load "junegunn/fzf"

zinit ice wait"2" lucid as"program" pick"bin/git-dsf"
zinit load zdharma/zsh-diff-so-fancy

zinit ice from"gh-r" as"program" mv"bat* -> bat" pick"bat/bat" atload"alias cat='bat'"
zinit load sharkdp/bat

zinit ice from"gh-r" as"program" mv"mdcat* -> mdcat" pick"mdcat/mdcat"
zinit load lunaryorn/mdcat

zinit ice from"gh-r" as"program" bpick"tig-*.tar.gz" atclone"cd tig-*/; ./configure; make" atpull"%atclone" pick"*/src/tig"
zinit light "jonas/tig"

zinit wait'1' lucid from"gh-r" as"program" light-mode for @high-moctane/nextword

hash tig &>/dev/null && zinit wait lucid for zdharma/zsh-tig-plugin

zinit ice from"gh-r" as"program" pick"so/so"
zinit load samtay/so

# zinit ice lucid wait from"gh-r" as"program" pick"./*/*/nvim"
# zinit load neovim/neovim

zinit ice from"gh-r" as"program"
zinit load extrawurst/gitui

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

# zi_completion has'pandoc'
zinit light srijanshetty/zsh-pandoc-completion

# zinit ice wait:2 lucid extract"" from"gh-r" as"command" mv"exa* -> exa"
# zinit load ogham/exa

zinit ice wait:2 lucid extract"" from"gh-r" as"command" mv"taskwarrior-tui* -> tt"
zinit load kdheepak/taskwarrior-tui

zinit load "b4b4r07/emoji-cli"

zinit ice wait"0" pick"iterm2.plugin.zsh" lucid; zinit snippet OMZ::plugins/iterm2/iterm2.plugin.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/git.zsh
# zinit snippet PZT::modules/completion/init.zsh

zinit light zdharma/fast-syntax-highlighting

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

export FZF_TMUX_HEIGHT='95%'

zinit load Aloxaf/fzf-tab

# zstyle ':fzf-tab:*' show-group full
# zstyle ':fzf-tab:*' single-group ''
# zstyle ':fzf-tab:*' single-group color $'\033[30m'
# zstyle ':fzf-tab:*' prefix ''
# zstyle ':fzf-tab:*' continuous-trigger 'alt-enter'
# Previews for some commands

zstyle ':completion:complete:*:options' sort false
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' single-group ''
zstyle ':fzf-tab:complete:_zlua:*' query-string input

zstyle ':completion:*' special-dirs true

zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ":fzf-tab:complete:(exa|bat|nvim):*" fzf-preview '
  bat --style=numbers --color=always --line-range :250 $realpath 2>/dev/null ||
  exa -1 --color=always --icons --group-directories-first $realpath
'
# give a preview of commandline arguments when completing `kill`
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

### End of Zinit's installer chunk

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/$USER/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/$USER/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/$USER/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/$USER/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

alias luamake=/Users/dkrishna/gitrepos/lua-language-server/3rd/luamake/luamake
