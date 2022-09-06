#-*- mode: sh -*-

# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

#
# Browser
#

#
# Language
#

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the the list of directories that cd searches.
# cdpath=(
#   $cdpath
# )

# Set the list of directories that Zsh searches for programs.
# path=(
# #  /usr/local/{bin,sbin}
#   $path
# )
#

find-up () {
  path=$(pwd)

  while [[ "$path" != "" ]]; do
    [ -e "$path/$1" ] && echo $path/$1 && return
    path=${path%/*}
  done
}

export PYENV_ROOT="$HOME/.pyenv"

# nvm
# !!! This is a source of some shell startup slowness
# !!! Make sure node is not installed via brew or apt
# !!! TODO: Force zsh to push nvm node path in front of /usr/bin /usr/local/bin
# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

path=(
  ./bin
  $HOME/bin
  $HOME/bin/ssh
  $HOME/bin/mount
  $HOME/.emacs.d/bin
  /opt/homebrew/opt/grep/libexec/gnubin
  /usr/local/sbin
  /usr/local/{bin,sbin}
  $path
)

dev() {
  # pyenv
  python_version=$(find-up .python-version)
  if [[ ! -z $python_version ]]; then
    echo "Loading pyenv $python_version"
    path=($PYENV_ROOT/bin $path)
    eval "$(pyenv init -)"
  fi

  # pyvenv
  python_env=$(find-up env)
  if [[ ! -z $python_env ]]; then
    echo "Setting WORKON_HOME to $python_env"
    export WORKON_HOME=$python_env
    echo "Activating python env $python_env"
    . $python_env/bin/activate
  fi

  # rbenv
  ruby_version=$(find-up .ruby-version)
  if [[ ! -z $ruby_version ]]; then
    echo "Loading rbenv $ruby_version"
    path=($HOME/.rbenv/bin $path)
    eval "$(rbenv init - --no-rehash)"
  fi

  # nvmrc
  node_version=$(find-up .nvmrc)
  if [[ ! -z $node_version ]]; then
    echo "Loading nvm $node_version"
    export NVM_DIR="$HOME/.nvm"
    path=(./node_modules/.bin, $path)
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    nvm use
  fi

  # rust
  . "$HOME/.cargo/env"
  export RUST_SRC_PATH=$(rustc --print sysroot)/lib/rustlib/src/rust/library
}

#
# Less
#

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$USER"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
  mkdir -p "$TMPPREFIX"
fi

# Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"
