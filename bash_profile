if [ -f "$HOME/.bashrc" ]; then
    . "$HOME/.bashrc"
fi

# >>> gams initialize >>>
# !! Contents within this block are managed by a gams installer script !!
export PATH="$HOME/.local/bin/gams47.3_osx_arm64:$PATH"
# <<< gams initialize <<<
