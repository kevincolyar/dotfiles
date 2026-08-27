# Stow: ~/.dotfiles/zsh/.zshrc -> ~/.zshrc
# Source: nix/.config/nix/home.nix programs.zsh + HM fzf/starship/direnv/history/keychain

[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

typeset -U path cdpath fpath manpath

if [[ -n ${NIX_PROFILES-} ]]; then
  for profile in ${(z)NIX_PROFILES}; do
    fpath+=($profile/share/zsh/site-functions $profile/share/zsh/$ZSH_VERSION/functions $profile/share/zsh/vendor-completions)
  done
fi

# First readable plugin path. Nix profile then Debian/Ubuntu /usr/share. Never Homebrew.
_zsh_source_first() {
  local f
  for f in "$@"; do
    if [[ -r $f ]]; then
      source "$f"
      return 0
    fi
  done
  return 1
}

autoload -Uz compinit
_zcompdump="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump-$ZSH_VERSION"
mkdir -p "${_zcompdump:h}"
compinit -d "$_zcompdump"
unset _zcompdump

HISTSIZE=10000
SAVEHIST=10000
HISTFILE="${ZDOTDIR:-$HOME}/.zsh_history"
mkdir -p "$(dirname "$HISTFILE")"
setopt HIST_FCNTL_LOCK HIST_IGNORE_DUPS HIST_IGNORE_SPACE SHARE_HISTORY
unsetopt APPEND_HISTORY EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FIND_NO_DUPS HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS

bindkey -v

ulimit -n 65536

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 'r:|=*' 'l:|=*'

setopt AUTO_MENU
setopt CORRECT
setopt REC_EXACT

path=(
  ./bin
  $HOME/bin
  $HOME/bin/ssh
  $HOME/bin/mount
  $HOME/.docker/bin
  $path
)

if [[ -d /opt/homebrew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
if [[ -d /usr/local/Homebrew ]]; then
  eval "$(/usr/local/Homebrew/bin/brew shellenv)"
fi

export EDITOR="emacs -nw"
export COLORTERM="truecolor"
export GPG_TTY=$(tty)
export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc
export PYREFLY_STACK_SIZE=100000000

_zsh_source_first \
  ${HOME}/.nix-profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /etc/profiles/per-user/${USER}/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  ${HOME}/.local/state/nix/profiles/profile/share/zsh-autosuggestions/zsh-autosuggestions.zsh \
  /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
ZSH_AUTOSUGGEST_STRATEGY=(history)

# fzf --zsh needs 0.48+. Ubuntu 20.04/22.04 fzf has no --zsh; fall back to shell scripts.
# fzf-tab native module is Nix-built; Ubuntu zsh cannot load it and then
# prompts to rebuild. x86_64-linux uses a copy with no .so (zsh fallback).
if (( $+commands[fzf] )); then
  if [[ $options[zle] = on ]]; then
    if fzf_zsh_init=$(fzf --zsh 2>/dev/null); then
      eval "$fzf_zsh_init"
    else
      _fzf_share=$(command fzf-share 2>/dev/null) || _fzf_share=""
      _zsh_source_first \
        ${_fzf_share:+$_fzf_share/key-bindings.zsh} \
        /usr/share/doc/fzf/examples/key-bindings.zsh \
        /usr/share/fzf/key-bindings.zsh \
        /usr/share/fzf/shell/key-bindings.zsh
      _zsh_source_first \
        ${_fzf_share:+$_fzf_share/completion.zsh} \
        /usr/share/doc/fzf/examples/completion.zsh \
        /usr/share/fzf/completion.zsh \
        /usr/share/fzf/shell/completion.zsh
      unset _fzf_share
    fi
    unset fzf_zsh_init
  fi

  FZF_TAB_MODULE_BUILD=0
  zstyle ':fzf-tab:*' use-fzf-default-opts yes
  _fzf_tab=
  for _fzf_tab in \
    ${HOME}/.nix-profile/share/fzf-tab/fzf-tab.plugin.zsh \
    /etc/profiles/per-user/${USER}/share/fzf-tab/fzf-tab.plugin.zsh \
    ${HOME}/.local/state/nix/profiles/profile/share/fzf-tab/fzf-tab.plugin.zsh \
    /usr/share/fzf-tab/fzf-tab.plugin.zsh
  do
    [[ -r $_fzf_tab ]] && break
    _fzf_tab=
  done
  if [[ -n $_fzf_tab ]]; then
    if [[ $OSTYPE == linux-gnu* && $CPUTYPE == x86_64 && $_fzf_tab != /usr/share/* ]]; then
      _fzf_tab_nomod="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/fzf-tab-nomodule"
      if [[ ! -e $_fzf_tab_nomod/fzf-tab.plugin.zsh || $_fzf_tab -nt $_fzf_tab_nomod/fzf-tab.plugin.zsh ]]; then
        mkdir -p "$_fzf_tab_nomod"
        cp -f "${_fzf_tab:h}/fzf-tab.plugin.zsh" "${_fzf_tab:h}/fzf-tab.zsh" "$_fzf_tab_nomod/"
        ln -sfn "${_fzf_tab:h}/lib" "$_fzf_tab_nomod/lib"
        rm -rf "$_fzf_tab_nomod/modules"
      fi
      source "$_fzf_tab_nomod/fzf-tab.plugin.zsh"
    else
      source "$_fzf_tab"
    fi
  fi
  unset _fzf_tab _fzf_tab_nomod
fi

(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"

if [[ $TERM != "dumb" ]] && (( $+commands[starship] )); then
  eval "$(starship init zsh)"
fi

# Host modules (is-kevinc, mini, kubi). Skip without local id_rsa — breaks agent forwarding.
if (( $+commands[keychain] )) && [[ -f $HOME/.ssh/id_rsa ]]; then
  eval "$(SHELL=zsh keychain --eval --quiet id_rsa)"
fi

(( $+commands[direnv] )) && eval "$(direnv hook zsh)"

alias -- ..=cd\ ..
alias -- less='less -R'
alias -- du='dua -i .git -i node_modules interactive'
alias -- cat=bat
alias -- e='emacs -nw'
alias -- ec='emacsclient -t'
alias -- ls='eza --git'
alias -- l='eza -lgh'
alias -- ll='eza -lgah'
alias -- la='ls -lAGh --color'
alias -- gl='git pull'
alias -- gp='git push'
alias -- gd='git diff'
alias -- gc='git commit'
alias -- gca='git commit -a'
alias -- gco='git checkout'
alias -- gb='git branch'
alias -- gs='git status'
alias -- grm='git status | grep deleted | awk '\''{print $3}'\'' | xargs git rm'
alias -- git_diff='git diff --no-ext-diff -w '\''$@'\'' | vim -R -'
alias -- glg='git log --graph --pretty=format:'\''%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'\'' --abbrev-commit'
alias -- dc='docker compose'
alias -- dcl='docker compose -f docker-compose.yml -f docker-compose.local.yml'
alias -- k8=kubectl
alias -- vi=vim
alias -- vim=nvim
alias -- curl='noglob curl'
alias -- wget='noglob wget'
alias -- git='noglob git'
alias -- px='proxychains4 -q'

_zsh_source_first \
  ${HOME}/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /etc/profiles/per-user/${USER}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  ${HOME}/.local/state/nix/profiles/profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh \
  /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main)

unset -f _zsh_source_first
