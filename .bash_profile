
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
