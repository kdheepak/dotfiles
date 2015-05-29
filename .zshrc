# Path to your oh-my-zsh installation.
export ZSH=/Users/dkrishna/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="robbyrussell"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git history history-substring-search terminalapp brew )

fpath=(/usr/local/share/zsh-completions $fpath)
# User configuration

export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
# export MANPATH="/usr/local/man:$MANPATH"

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# added by Anaconda 2.1.0 installer
export PATH="/Users/$USER/anaconda/bin:$PATH"

export PATH="/Users/$USER/Documents/gridlabd/bin:$PATH"
export PATH="/Users/$USER/Documents/GitRepos/macvim/src/MacVim:$PATH"
export EDITOR='mvim -f --nomru -c "au VimLeave * !open -a Terminal"'
export GIT_EDITOR='mvim -f --nomru -c "au VimLeave * !open -a Terminal"'
#export EDITOR="/usr/local/Cellar/emacs/24.4/Emacs.app/Contents/MacOS/Emacs -nww"
#alias vim='mvim -v'
#alias vi='mvim -v'
#alias vim="/usr/local/Cellar/emacs/24.4/Emacs.app/Contents/MacOS/Emacs -nw"
#alias vi="/usr/local/Cellar/emacs/24.4/Emacs.app/Contents/MacOS/Emacs -nw"
alias emacs="/usr/local/Cellar/emacs/24.4/Emacs.app/Contents/MacOS/Emacs -nw"

if [[ $TERM == xterm ]]; then
    TERM=xterm-256color
fi

unsetopt correct_all  
setopt correct

cdf() {
    target=`osascript -e 'tell application "Finder" to if (count of Finder windows) > 0 then get POSIX path of (target of front Finder window as text)'`
    if [ "$target" != "" ]; then
	cd "$target"; pwd
    else
	echo 'No Finder window found' >&2
    fi
    }

#export DYLD_LIBRARY_PATH="/opt/local/lib:/usr/local/openmpi/lib:/usr/local/lib:$DYLD_LIBRARY_PATH"

#PROMPT="%{$fg[red]%}%n%{$reset_color%}@%{$fg[blue]%}%m %{$fg_no_bold[yellow]%}%1~ %{$reset_color%}%#"

source /Users/$USER/Documents/GitRepos/oh-my-git/prompt.sh

#educe time it take for tab completion
__git_files () {
  _wanted files expl 'local files' _files
}

zstyle ':completion:*' add-space true
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*' menu select=1
zstyle ':completion:*' file-sort name
zstyle ':completion:*' list-colors ${(s.:.)ZLS_COLORS}
zstyle ':completion:*' matcher-list 'r:|[._-]=** r:|=**' 'l:|=** r:|=**'
zstyle ':completion:*' menu select
zstyle ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

#[ Formats ]####################################################################
zstyle ':completion:*' group 1
zstyle ':completion:*' format '%B---- %d%b'
zstyle ':completion:*:corrections' format '%B---- %d (errors %e)%b'
zstyle ':completion:*:descriptions' format "%B---- %d%b"
zstyle ':completion:*:messages' format '%B%U---- %d%u%b' 
zstyle ':completion:*:warnings' format "%B$fg[red]%}---- no match for: $fg[white]%d%b"
zstyle ':completion:*' group-name ''

#[ Kill ]#######################################################################
zstyle ':completion:*:processes' command 'ps -au$USER -o pid,time,cmd|grep -v "ps -au$USER -o pid,time,cmd"'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)[ 0-9:]#([^ ]#)*=01;30=01;31=01;38'

#[ hosts and users ]############################################################
#hosts=()
#[ -r ~/.ssh/config ] && hosts=(${${${$(grep '^Host' ~/.ssh/config)}##Host }##[*0-9]*})
#[ -r ~/.ssh/known_hosts ] && hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[0-9]*}%\*}%,*})
hosts=($( ( \
        ( [ -r ~/.ssh/config ] && awk '/^host +[a-z]/ { print $2 }' ~/.ssh/config) ; \
        ( [ -r ~/.ssh/known_hosts ] && awk '{print $1}' ~/.ssh/known_hosts | tr , '\n') \
) | sort -u))

zstyle ':completion:*' hosts $hosts
zstyle ':completion:*:hosts' list-colors '=(#b)(*)(.jukie.net)=01;30=01;31' '=[^.]#=01;31'

users=(root)
zstyle ':completion:*' users $users

zstyle ':completion:*:*:[ak]dvi:*' file-patterns \
    '*.dvi:dvi-files:DVI\ files *(-/):directories:Directories' '*:all-files'
zstyle ':completion:*:*:kghostview:*' file-patterns \
    '*.(ps|pdf)(|.gz|.bz2):pspdf-files:PostScript\ or\ PDF\ files  *(-/):directories:Directories' '*:all-files'
zstyle ':completion:*:*:swfplayer:*' file-patterns \
    '*.swf:swf-files:Swf\ files  *(-/):directories:Directories' '*:all-files'

zstyle ':completion:*' file-patterns \
    '%p:globbed-files: *(-/):directories:Directories' '*:all-files'

#[ ignores for vim ]############################################################

zstyle ':completion:*:*:vi(m|):*:*files' ignored-patterns '*?.(aux|dvi|ps|pdf|bbl|toc|lot|lof|o|cm?)'

echo 'Sourced .zshrc successfully'
