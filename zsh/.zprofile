#-*- mode: sh -*-

# Executes commands at login pre-zshrc.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Language
#-------------------------------------------------------------------------------------
if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

# Paths
#-------------------------------------------------------------------------------------

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path


find-up () {
  path=$(pwd)

  while [[ "$path" != "" ]]; do
    [ -e "$path/$1" ] && echo $path/$1 && return
    path=${path%/*}
  done
}

export PYENV_ROOT="$HOME/.pyenv"

path=(
  ./bin
  $HOME/bin
  $HOME/bin/ssh
  $HOME/bin/mount
  $HOME/.emacs.d/bin
  $HOME/.docker/bin
  /opt/homebrew/opt/grep/libexec/gnubin
  /usr/local/opt/grep/libexec/gnubin
  # Fix for emacs+gpg+brew
  /opt/homebrew/opt/gnupg@2.2/bin
  /usr/local/sbin
  /usr/local/{bin,sbin}
  $path
)

# Dev Runtime Helper
#-------------------------------------------------------------------------------------
dev() {
  # pyenv
  python_version=$(find-up .python-version)
  if [[ ! -z $python_version ]]; then
    echo "Loading pyenv $python_version"
    path=($PYENV_ROOT/bin $path)
    eval "$(pyenv init -)"

    function pip-install-save() { 
      pip install $1 && pip freeze | grep $1 >> requirements.txt
    }
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

  # golang
  export GOPATH="$(go env GOPATH)"
  export PATH="${PATH}:${GOPATH}/bin"
}

# Temporary Files
#-------------------------------------------------------------------------------------
if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$USER"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
  mkdir -p "$TMPPREFIX"
fi

# Homebrew
#-------------------------------------------------------------------------------------
if [[ -d /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [[ -d /usr/local/Homebrew ]]; then
  eval "$(/usr/local/Homebrew/bin/brew shellenv)"
fi
