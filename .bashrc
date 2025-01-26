# 
# ~/.bashrc
#
# ~~~~~~~~~~~~~~~ Environment Variables ~~~~~~~~~~~~~~~~~~~~~~~~
# ~~~~~~~~~~~~~~~ Taken from mischavandenburg ~~~~~~~~~~~~~~~~~~~~~~~~

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Set to superior editing mode
set -o vi

# Editor and terminal settings
export VISUAL=nvim
export EDITOR=nvim
export TERM="tmux-256color"

# config
export BROWSER="chrome"

# Directories
export REPOS="$HOME/Repos"
export GITUSER="pedrotchang"
export GHREPOS="$REPOS/github.com/$GITUSER"
export DOTFILES="$GHREPOS/dotfiles"
export LAB="$GHREPOS/lab"
export SCRIPTS="$DOTFILES/scripts"
export SECONDBRAIN="$HOME/secondbrain"

# ~~~~~~~~~~~~~~~ Path configuration ~~~~~~~~~~~~~~~~~~~~~~~~

# Create PATH with custom directories
PATH="/opt/homebrew/opt/curl/bin:$PATH"  # Homebrew curl
PATH="/opt/local/bin:$PATH"
PATH="$HOME/bin:$PATH"
PATH="$HOME/.local/bin:$PATH"
PATH="/root/.local/bin:$PATH"            # Dev Container Specifics

# Remove duplicate PATH entries while preserving order
PATH=$(echo "$PATH" | awk -v RS=':' -v ORS=":" '!a[$1]++' | sed 's/:$//')
export PATH

# Source asdf
. "$HOME/.asdf/asdf.sh"

# ~~~~~~~~~~~~~~~ Functions ~~~~~~~~~~~~~~~~~~~~~~~~

# This function is stolen from mischavandenburg who stole it from rwxrob

clone() {
  local repo="$1" user
  local repo="${repo#https://github.com/}"
  local repo="${repo#git@github.com:}"
  if [[ $repo =~ / ]]; then
    user="${repo%%/*}"
  else
    user="$GITUSER"
    [[ -z "$user" ]] && user="$USER"
  fi
  local name="${repo##*/}"
  local userd="$REPOS/github.com/$user"
  local path="$userd/$name"
  [[ -d "$path" ]] && cd "$path" && return
  mkdir -p "$userd"
  cd "$userd"
  echo gh repo clone "$user/$name" -- --recurse-submodule
  gh repo clone "$user/$name" -- --recurse-submodule
  cd "$name"
} && export -f clone

# ~~~~~~~~~~~~~~~ Prompt ~~~~~~~~~~~~~~~~~~~~~~~~

# Starship
eval "$(starship init bash)"

# ~~~~~~~~~~~~~~~ Aliases ~~~~~~~~~~~~~~~~~~~~~~~~

# General
alias v=nvim
alias c="clear"
alias hb='history | fzf'

# Navigation
alias ..="cd .."
alias scripts='cd $SCRIPTS'

# Repository management
alias lab='cd $LAB'
alias dot='cd $GHREPOS/dotfiles/'
alias gr='cd $GHREPOS'
alias mvdot='cd $REPOS/github.com/mischavandenburg/dotfiles'


# Directory shortcuts
alias icloud="cd \$ICLOUD"

# ls variants
alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -A'
alias lla='ll -A'


# Git shortcuts
alias g='git'
alias gp='git pull'
alias gs='git status'
alias lg='lazygit'
alias go='git log --oneline'

# kubectl
alias k='kubectl'
source <(kubectl completion bash)
complete -o default -F __start_kubectl k
alias kgp='kubectl get pods'
alias kc='kubectx'
alias kn='kubens'

alias kcs='kubectl config use-context admin@homelab-staging'
alias kcp='kubectl config use-context admin@homelab-production'

# flux
source <(flux completion bash)
alias fgk='flux get kustomizations'

# completions
source <(talosctl completion bash)
source <(kubectl-cnp completion bash)
source <(cilium completion bash)
source <(devpod completion bash)

# fzf aliases
# use fp to do a fzf search and preview the files
alias fp="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"
# search for a file with fzf and open it in vim
alias vf='v $(fp)'

# sourcing
source "$HOME/.privaterc"


if [[ "$OSTYPE" == "darwin"* ]]; then
  source "$HOME/.fzf.bash"
  # echo "I'm on Mac!"

  # brew bash completion
  [[ -r "/opt/homebrew/etc/profile.d/bash_completion.sh" ]] && . "/opt/homebrew/etc/profile.d/bash_completion.sh"
else
  #	source /usr/share/fzf/key-bindings.bash
  #	source /usr/share/fzf/completion.bash

  # The first one worked on Ubuntu, the eval one on Fedora. Keeping for reference.
  # [ -f ~/.fzf.bash ] && source ~/.fzf.bash
	[ -f ~/.fzf.bash ] && source ~/.fzf.bash
fi

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/seyza/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)






[ -f ~/.fzf.bash ] && source ~/.fzf.bash
. "$HOME/.cargo/env"
