
if [ -f $HOME/.bashrc ]; then
        source $HOME/.bashrc
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        eval "$("$BASE16_SHELL/profile_helper.sh")"
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

export PATH="$PATH:$HOME/Applications/Julia-1.3.app/Contents/Resources/julia/bin/"
