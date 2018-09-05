colorscheme gruvbox

set global tabstop 4
set global indentwidth 4
set-option global BOM none
set-option global eolformat lf
set-option global ui_options ncurses_assistant=cat
set-option global autoreload yes
set-option global scrolloff 3,5
set-option global makecmd 'make --jobs=4'

# Use ripgrep as grep
set-option global grepcmd 'rg --column --with-filename'

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
hook global WinCreate .* %{ autowrap-enable }

# vim old habits
map global normal D '<a-l>d' -docstring 'delete to end of line'
map global normal Y '<a-l>y' -docstring 'yank to end of line'

# Delete from line begin to the current position
map global normal <a-D> '<a-h>d'
# Copy from line begin to the current position
map global normal <a-Y> '<a-h>y'

map global normal '#' :comment-line<ret> -docstring 'comment line'
map global normal '<a-#>' :comment-block<ret> -docstring 'comment block'

map global goto m '<esc>m;' -docstring 'matching char'

# add line numbers

hook global WinCreate .* %{
  addhl window/wrap wrap
  addhl window/number-lines number-lines -relative -hlcursor
  addhl window/show-whitespaces show-whitespaces -tab '›' -tabpad '⋅' -lf ' ' -spc ' ' -nbsp '⍽'
  addhl window/show-matching show-matching
  addhl window/VisibleWords regex \b(?:FIXME|TODO|XXX)\b 0:default+rb

  smarttab-enable
  tab-completion-enable
  show-trailing-whitespace-enable; face window TrailingWhitespace default,magenta
  search-highlighting-enable; face window Search +bi
  volatile-highlighting-enable; face window Volatile +bi
}

# relative line numbers
hook global WinCreate .* %{addhl number_lines -relative}

map global normal <%> '<c-s>%' # Save position before %
map global normal <x> <a-x>

######################################################
# https://github.com/mawww/kakoune/wiki/Bc
# Incrementing / decrementing numbers
def -hidden -params 2 inc %{ %sh{
    if [ "$1" = 0 ]
    then
        count=1
    else
        count="$1"
    fi
    printf '%s%s\n' 'exec h"_/\d<ret><a-i>na' "$2($count)<esc>|bc<ret>h"
} }
map global normal <c-a> ':inc %val{count} +<ret>'
map global normal <c-x> ':inc %val{count} -<ret>'

map global object q Q -docstring 'double quote string'
map global object Q q -docstring 'single quote string'

## More:
# Git extras.
def git-show-blamed-commit %{
  git show %sh{git blame -L "$kak_cursor_line,$kak_cursor_line" "$kak_buffile" | awk '{print $1}'}
}
def git-log-lines %{
  git log -L %sh{
    anchor="${kak_selection_desc%,*}"
    anchor_line="${anchor%.*}"
    echo "$anchor_line,$kak_cursor_line:$kak_buffile"
  }
}
def git-toggle-blame %{
  try %{
    addhl window/git-blame group
    rmhl window/git-blame
    git blame
  } catch %{
    git hide-blame
  }
}
def git-hide-diff %{ rmhl window/git-diff }

declare-user-mode git
map global git b ': git-toggle-blame<ret>'       -docstring 'blame (toggle)'
map global git l ': git log<ret>'                -docstring 'log'
map global git c ': git commit<ret>'             -docstring 'commit'
map global git d ': git diff<ret>'               -docstring 'diff'
map global git s ': git status<ret>'             -docstring 'status'
map global git h ': git show-diff<ret>'          -docstring 'show diff'
map global git H ': git-hide-diff<ret>'          -docstring 'hide diff'
map global git w ': git-show-blamed-commit<ret>' -docstring 'show blamed commit'
map global git L ': git-log-lines<ret>'          -docstring 'log blame'

# Highlight trailing whitespace in normal mode, with the TrailingWhitespace face.
# What I really want is to only not highlight trailing whitespace as I'm
# inserting it, but that doesn't seem possible right now.
def show-trailing-whitespace-enable %{
  # addhl window/TrailingWhitespace regex \h+$ 0:TrailingWhitespaceActive
  # face window TrailingWhitespaceActive TrailingWhitespace
  hook -group trailing-whitespace window ModeChange 'normal:insert' \
    %{ face window TrailingWhitespaceActive '' }
  hook -group trailing-whitespace window ModeChange 'insert:normal' \
    %{ face window TrailingWhitespaceActive TrailingWhitespace }
}
def show-trailing-whitespace-disable %{
  rmhl window/TrailingWhitespace
  rmhooks window trailing-whitespace
}
face global TrailingWhitespace ''

def switch-to-modified-buffer %{
  eval -save-regs a %{
    reg a ''
    try %{
      eval -buffer * %{
        eval %sh{[ "$kak_modified" = true ] && echo "reg a %{$kak_bufname}; fail"}
      }
    }
    eval %sh{[ -z "$kak_main_reg_a" ] && echo "fail 'No modified buffers!'"}
    buffer %reg{a}
  }
}

define-command trim-whitespaces %{
   try %{
        exec -draft '%s\h+$<ret>d'
        echo -markup "{Information}trimmed"
    } catch %{
        echo -markup "{Information}nothing to trim"
    }
}

# Grep navigation
hook global BufOpenFifo '\Q*grep*' %{
    map global normal <c-n> ':grep-next-match<ret>'
    map global normal <c-p> ':grep-previous-match<ret>'
}

# Make navigation
hook global BufOpenFifo '\Q*make*' %{
    map global normal <c-n> ':make-next-error<ret>'
    map global normal <c-p> ':make-previous-error<ret>'
}

# Restore global mappings
hook global BufCloseFifo '\*(grep|make)\*' %{
    map global normal <c-n> ':buffer-next<ret>'
    map global normal <c-p> ':buffer-previous<ret>'
}


# Indent or deindent when the <tab> is pressed
# map global normal <tab>   '<a-;><gt>'
# map global normal <s-tab> '<a-;><lt>'

# User mappings ────────────────────────────────────────────────────────────────

# Paste from system register
map global user p '!xsel --output --clipboard<ret>' -docstring "paste after"
map global user P '<a-!>xsel --output --clipboard<ret>' -docstring "paste before"

# Replace from system register
map global user R '|xsel --output --clipboard<ret>' -docstring "replace"

# Toggle word wrapping
map global user w ':toggle-highlighter window/wrap wrap -word -indent -width 100 <ret>' -docstring 'wrap'

# Select all occurences of the main selection
map global user a '*%s<ret>' -docstring "select all"

# Show length of selection
map global user s ':selection-length<ret>' -docstring "selection length"

# Trim all whitespaces
map global user t ':trim-whitespaces<ret>' -docstring "trim whitespaces"

# Expand selection to outer scope
map global user e ':expand<ret>' -docstring "expand"

# 'lock' mapping where pressing 'e' repeatedly will expand the selection
declare-user-mode expand
map global user E ':expand; enter-user-mode -lock expand<ret>' -docstring "expand ↻"
map global expand e ':expand<ret>' -docstring "expand"

# Select all lines directly below, above and both that contain the current selection at the same position
map global user v     ':select-down<ret>' -docstring "select down"
map global user <a-v> ':select-up<ret>' -docstring "select up"
map global user V     ':select-vertically<ret>' -docstring "select all up/down"

# Highlighters ─────────────────────────────────────────────────────────────────

# Highlight trailing spaces
add-highlighter global/trailing_white_spaces regex \h+$ 0:Error

# File-types ───────────────────────────────────────────────────────────────────

# Add autowrap to 72 characters in git-commit
hook -group GitWrapper global WinSetOption filetype=git-commit %{
    set-option buffer autowrap_column 72
    autowrap-enable
    hook window WinSetOption filetype=(?!git-commit).* %{ autowrap-disable }
}

