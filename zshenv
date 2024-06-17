source ~/.config/.aliases

if [ -d $HOME/.zsh/comp ]; then
    export FPATH="$HOME/.zsh/comp:$FPATH"
fi
. "$HOME/.cargo/env"
