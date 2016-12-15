
plugins=(git history history-substring-search terminalapp brew zsh-completions)

# alias vim='mvim -v'
alias vim=nvim
alias vi=nvim

export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export TERM=xterm-256color

# tmux aliases
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'

ZSH_THEME="powerlevel9k/powerlevel9k" 

source $ZSH/oh-my-zsh.sh

export ZSH_THEME="powerlevel9k/powerlevel9k"
POWERLEVEL9K_DIR_BACKGROUND='blue'
POWERLEVEL9K_DIR_FOREGROUND='white'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
# POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX="↱"
# POWERLEVEL9K_MULTILINE_SECOND_PROMPT_PREFIX="↳ "
POWERLEVEL9K_MODE='awesome-patched'


# redefine prompt_context for hiding user@hostname
prompt_context () { }

# Don't show context
export DEFAULT_USER=<username>


export VISUAL=nvim
export EDITOR="$VISUAL"



# Load zsh-syntax-highlighting.
source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Load zsh-autosuggestions.
# export AUTOSUGGESTION_ACCEPT_RIGHT_ARROW=1
# source ~/.zsh/zsh-autosuggestions/autosuggestions.zsh

# Enable autosuggestions automatically.
# zle-line-init() {
#     zle autosuggest-start
# }
# zle -N zle-line-init
# 

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.


echo 'Successfully sourced zshrc'
