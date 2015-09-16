
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

echo 'Successfully sourced zshrc'
