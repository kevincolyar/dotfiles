#-*- mode: sh -*-

#!!!  PATH changes are in .zprofile !!!
#
# This file should contain only settings for interactive sessions
#

# Exports
#-------------------------------------------------------------------------------------
export GPG_TTY=`tty` # Required by gnupg-vim
export TERMINFO_DIRS=$TERMINFO_DIRS:$HOME/.local/share/terminfo
export PLATFORM=$(uname)
export EDITOR='nvim'
export GREP_COLOR='1;33'
# export PAGER='less -r'
# export PAGER='most'
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

export -U DIAG_ADR_ENABLED=off  # Disable creation of oradiag directory

export REPORTTIME=10 # print elapsed time when more than 10 seconds

# History settings
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE=$HOME/.zsh_history
export HISTIGNORE="&:ls:ll:la:l.:pwd:exit:clear:clr:[bf]g"

# Fixes vi-mode esc lag
export KEYTIMEOUT=5 

# http://hoelz.ro/blog/making-ssh_auth_sock-work-between-detaches-in-tmux
if [ ! -z "$SSH_AUTH_SOCK" -a "$SSH_AUTH_SOCK" != "$HOME/.ssh/.auth_sock" ] ; then
    unlink "$HOME/.ssh/.auth_sock" 2>/dev/null
    ln -s "$SSH_AUTH_SOCK" "$HOME/.ssh/.auth_sock"
    export SSH_AUTH_SOCK="$HOME/.ssh/.auth_sock"
fi

# Options
#-------------------------------------------------------------------------------------

setopt append_history
setopt inc_append_history
setopt extended_history
setopt hist_find_no_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space
setopt hist_no_store
setopt hist_no_functions
setopt no_hist_beep
setopt hist_save_no_dups
setopt hist_verify
setopt share_history # share history between sessions ???
setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt PROMPT_SUBST
unsetopt correct_all
setopt COMPLETE_IN_WORD
setopt IGNORE_EOF
setopt rmstarsilent # Don't confirm `rm *
setopt COMPLETE_ALIASES # autocompletion of command line switches for aliases

# Key Bindings
#-------------------------------------------------------------------------------------

zle -N newtab

bindkey '^[^[[D' backward-word
bindkey '^[^[[C' forward-word
bindkey '^[[5D' beginning-of-line
bindkey '^[[5C' end-of-line
bindkey '^[[3~' delete-char
bindkey '^[^N' newtab
bindkey '^?' backward-delete-char
bindkey -M viins 'fd' vi-cmd-mode

# Vim Mode
bindkey -v

# Edit command line with ctrl-e
autoload edit-command-line; zle -N edit-command-line
bindkey '^e' edit-command-line

# See http://www.contextualdevelopment.com/articles/2006/zsh_history_searching
for keymap in v a; do
  bindkey -$keymap "^r" history-incremental-search-backward
  bindkey -$keymap "^s" history-incremental-search-forward
done

# Turn off flow control to let <Ctrl-s> passthrough to vim
stty -ixon

# Aliases
#-------------------------------------------------------------------------------------

# Bat instead of cat

# Exa instead of ls
alias ls="eza --git"
alias l="eza -lgh"
alias ll="eza -lgah"

alias ..='cd ..'
alias less="less -R"
alias du="dua -i .git -i node_modules interactive"

if [[ "$PLATFORM" == "Linux" ]]; then
  if ! type eza >> /dev/null; then
    alias ls="ls -FGh --color"
    alias l="ls -lAhG --color"
    alias ll="ls -lGh --color"
    alias la='ls -lAGh --color'
  fi
  alias du="ncdu -rr -x --exclude .git --exclude node_modules"
  alias cat='batcat'
elif [[ "$PLATFORM" == "Darwin" ]]; then
  if ! type eza > /dev/null; then
    alias ls="ls -FGh"
    alias l="ls -lahG"
    alias ll="ls -lGh"
    alias la="ls -laGh"
  fi
  # alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules"
  alias vim=nvim
  alias emacs="emacs -nw"
  alias cat='bat'
  alias e="emacs -nw"
fi

# apt
alias ai='sudo apt-get install'
alias au='sudo apt-get update'
alias as='apt-cache search'

# git
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gc='git commit'
alias gca='git commit -a'
alias gco='git checkout'
alias gb='git branch'
alias gs='git status'
alias grm="git status | grep deleted | awk '{print \$3}' | xargs git rm"
alias git_diff='git diff --no-ext-diff -w "$@" | vim -R -'
alias glg="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset %C(yellow) %an %Creset' --abbrev-commit --date=relative"

# docker
alias dc='docker compose'
alias dcl='docker compose -f docker-compose.yml -f docker-compose.local.yml'

# kubernetes
alias k8='kubectl'

# Other
alias vi='vim'
alias vim='nvim'
alias cask="brew cask"
alias be='noglob bundle exec'

# Commands starting with % for pasting from web
alias %=' '

# Globbing issues
alias curl='noglob curl'
alias wget='noglob wget'
alias git='noglob git'

if [[ `uname` == "Linux" ]]
then
  alias pbcopy='xclip -selection clipboard'
  alias pbpaste='xclip -selection clipboard -o'
fi

# Completion
#-------------------------------------------------------------------------------------

# Homebrew completion
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
fi

fpath=(~/.zsh/completion $fpath)
autoload -U compinit
compinit
zmodload -i zsh/complist
setopt hash_list_all            # hash everything before completion
setopt completealiases          # complete alisases
setopt always_to_end            # when completing from the middle of a word, move the cursor to the end of the word
setopt complete_in_word         # allow completion from within a word/phrase
setopt correct                  # spelling correction for commands
setopt list_ambiguous           # complete as much of a completion until it gets ambiguous.

zstyle ':completion::complete:*' use-cache on               # completion caching, use rehash to clear
zstyle ':completion:*' cache-path ~/.zsh/cache              # cache path
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'   # ignore case
zstyle ':completion:*' menu select=2                        # menu if nb items > 2
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # colorz !
zstyle ':completion:*::::' completer _expand _complete _ignored _approximate # list of completers to use

# sections completion !
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format $'\e[00;34m%d'
zstyle ':completion:*:messages' format $'\e[00;31m%d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zstyle ':completion:*:*:kill:*:processes' list-colors "=(#b) #([0-9]#)*=29=34"
zstyle ':completion:*:*:killall:*' menu yes select
zstyle ':completion:*:killall:*' force-list always
users=($USER root)
zstyle ':completion:*' users $users

#generic completion with --help
compdef _gnu_generic gcc
compdef _gnu_generic gdb

# Fuzzy match
zstyle ':completion:*' matcher-list '' \
       'm:{a-z\-}={A-Z\_}' \
       'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
       'r:|?=** m:{a-z\-}={A-Z\_}'

# Reset prompt if we're on a dumb terminal (Emacs TRAMP)
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '

if [[ "$PLATFORM" == "Linux" ]]; then
  # Debian keychain. Adds ssh key ssh-agent. Allows cronjobs to use ssh-agent
  # https://stackoverflow.com/questions/869589/why-ssh-fails-from-crontab-but-succedes-when-executed-from-a-command-line
  keychain --nogui id_rsa --quiet

fi

# Make GPG Agent available
gpg-agent --quiet

# Command-line Fuzzy Finder (eg, command history)
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Syntax Highlighting and Autocomplete (MUST BE AT END OF .zshrc)
if [[ "$PLATFORM" == "Linux" ]]; then
  . /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
elif [[ "$PLATFORM" == "Darwin" ]]; then
  if [[ -d /opt/homebrew/share ]]; then
    . /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    . /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  elif [[ -d /usr/local/share ]]; then
    . /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    . /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi
fi

# Turn on starship prompt
eval "$(starship init zsh)"
