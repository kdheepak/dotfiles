
if [ -f $HOME/.bashrc ]; then
        source $HOME/.bashrc
fi


# set -o errexit
# set -o pipefail
# set -o nounset

# export HISTCONTROL=ignoredups:erasedups  # no duplicate entries
# export HISTSIZE=100000                   # big big history
# export HISTFILESIZE=100000               # big big history
# export HISTIGNORE='ls:bg:fg:history:cat'
# export HISTTIMEFORMAT='%F %T '
# shopt -s histappend                      # append to history, don't overwrite it

# Save and reload the history after each command finishes
# export PROMPT_COMMAND="history -a; history -c; history -r; $PROMPT_COMMAND"

# shopt -s cmdhist

# bind 'set show-all-if-ambiguous on'
# bind 'set completion-ignore-case on'
# bind 'TAB:menu-complete'



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/$USER/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
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

