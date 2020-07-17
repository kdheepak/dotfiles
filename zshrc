# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

source ~/gitrepos/dotfiles/base16-github.fzf.config

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

POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    dir                     # current directory
    vcs                     # git status
    # =========================[ Line #2 ]=========================
    newline                 # \n
)
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
    timewarrior             # timewarrior tracking status (https://timewarrior.net/)
    taskwarrior             # taskwarrior task count (https://taskwarrior.org/)
    time                    # current time
    command_execution_time  # duration of the last command
    status                  # exit code of the last command
    background_jobs         # presence of background jobs
    direnv                  # direnv status (https://direnv.net/)
    asdf                    # asdf version manager (https://github.com/asdf-vm/asdf)
    virtualenv              # python virtual environment (https://docs.python.org/3/library/venv.html)
    anaconda                # conda environment (https://conda.io/)
    todo                    # todo items (https://github.com/todotxt/todo.txt-cli)
    # =========================[ Line #2 ]=========================
    newline
    # ip                    # ip address and bandwidth usage for a specified network interface
    # public_ip             # public IP address
    # proxy                 # system-wide http/https/ftp proxy
    # battery               # internal battery
    # wifi                  # wifi speed
    # example               # example user-defined segment (see prompt_example function below)
)
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

# zinit ice lucid wait from"gh-r" as"program" pick"./*/*/nvim"
# zinit load neovim/neovim

zinit ice lucid wait"0" as"program" from"gh-r" mv"lazygit* -> lazygit" atload"alias lg='lazygit'"
zinit load 'jesseduffield/lazygit'

zinit ice lucid wait"0" as"program" from"gh-r" mv"lazydocker* -> lazydocker"
zinit load 'jesseduffield/lazydocker'

zinit ice from"gh-r" as"program" mv"ripgrep* -> ripgrep" pick"ripgrep/rg"
zinit load BurntSushi/ripgrep

zinit ice depth'1' as"program" pick"ranger.py" atload"alias r='ranger.py'"
zinit load ranger/ranger

zinit ice as"command" from"gh-r" mv"fd* -> fd" pick"fd/fd"
zinit load sharkdp/fd

zinit ice as"command" extract"" pick"delta/delta" mv"delta* -> delta" from"gh-r"
zinit load dandavison/delta

zinit ice lucid wait"0" as"program" from"gh-r" pick"gh*/bin/gh"
zinit load "cli/cli"

# zinit ice wait:2 lucid extract"" from"gh-r" as"command" mv"exa* -> exa"
# zinit load ogham/exa

zinit load "b4b4r07/emoji-cli"

zinit ice wait"0" pick"iterm2.plugin.zsh" lucid; zinit snippet OMZ::plugins/iterm2/iterm2.plugin.zsh
zinit snippet OMZ::plugins/git/git.plugin.zsh
zinit snippet OMZ::lib/history.zsh
zinit snippet OMZ::lib/completion.zsh
zinit snippet OMZ::lib/git.zsh
# zinit snippet PZT::modules/completion/init.zsh

zinit ice wait'!0' lucid; zinit load "hlissner/zsh-autopair"

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
zinit snippet https://github.com/github/hub/raw/master/etc/hub.zsh_completion

zinit load Aloxaf/fzf-tab

# zstyle ':fzf-tab:*' show-group full
# zstyle ':fzf-tab:*' single-group ''
# zstyle ':fzf-tab:*' single-group color $'\033[30m'
# zstyle ':fzf-tab:*' prefix ''
# zstyle ':fzf-tab:*' continuous-trigger 'alt-enter'
# Previews for some commands
local extract="
in=\${\${\"\$(<{f})\"%\$'\0'*}#*\$'\0'}
local -A ctxt=(\"\${(@ps:\2:)CTXT}\")
"
local sanitized_in='${~ctxt[hpre]}"${${in//\\ / }/#\~/$HOME}"'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm,cmd -w -w"
zstyle ':fzf-tab:complete:cd:*' extra-opts --preview=$extract'exa -1 --color=always '$sanitized_in --preview-window=right:40%
zstyle ':fzf-tab:complete:exa:*' extra-opts --preview=$extract'exa -1 --color=always '$sanitized_in --preview-window=right:40%
zstyle ':fzf-tab:complete:nvim:*' extra-opts --preview=$extract'bat --pager=never --color=always --line-range :30 '$sanitized_in --preview-window=right:70%
zstyle ':fzf-tab:complete:bat:*' extra-opts --preview=$extract'bat --pager=never --color=always --line-range :30 '$sanitized_in --preview-window=right:70%
zstyle ':fzf-tab:complete:cat:*' extra-opts --preview=$extract'bat --pager=never --color=always --line-range :30 '$sanitized_in --preview-window=right:70%
zstyle ':fzf-tab:complete:vim:*' extra-opts --preview=$extract'bat --pager=never --color=always --line-range :30 '$sanitized_in --preview-window=right:70%

### End of Zinit's installer chunk
