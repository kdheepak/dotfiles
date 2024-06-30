if [ -f $HOME/.bashrc ]; then
        source $HOME/.bashrc
fi

# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] &&
        [ -s "$BASE16_SHELL/profile_helper.sh" ] &&
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

export PATH="$PATH:$HOME/.local/homebrew/bin"
. "$HOME/.cargo/env"

# >>> juliaup initialize >>>

# !! Contents within this block are managed by juliaup !!

case ":$PATH:" in
    *:/Users/kd/.juliaup/bin:*)
        ;;

    *)
        export PATH=/Users/kd/.juliaup/bin${PATH:+:${PATH}}
        ;;
esac

# <<< juliaup initialize <<<

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/kd/miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/kd/miniforge3/etc/profile.d/conda.sh" ]; then
        . "/Users/kd/miniforge3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/kd/miniforge3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

