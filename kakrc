colorscheme gruvbox

set global tabstop 4
set global indentwidth 4

# soft wrap
addhl global/ wrap

# this is going to be a really long line so that I can test the soft wrap of the editor kakoune. I can't really think of what to type over here

# Tab completions and tabstop 
hook global InsertCompletionShow .* %{
    try %{
        # this command temporarily removes cursors preceded by whitespace;
        # if there are no cursors left, it raises an error, does not
        # continue to execute the mapping commands, and the error is eaten
        # by the `try` command so no warning appears.
        execute-keys -draft 'h<a-K>\h<ret>'
        map window insert <tab> <c-n>
        map window insert <s-tab> <c-p>
    }
}
hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
}


# simulate Vim's textwidth (but hardcoded to some value)
# hook global BufNew .* autowrap-enable

# vim old habits
map global normal D '<a-l>d' -docstring 'delete to end of line'
map global normal Y '<a-l>y' -docstring 'yank to end of line'

map global normal '#' :comment-line<ret> -docstring 'comment line'
map global normal '<a-#>' :comment-block<ret> -docstring 'comment block'

map global goto m '<esc>m;' -docstring 'matching char'

# add line numbers
add-highlighter global/ number-lines
