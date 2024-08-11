export ZSH="$HOME/.oh-my-zsh"

plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh


bindkey -e

alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"

alias gc="git commit -m"
alias ga="git add *"
alias gp="git push"
alias gs="git status"

alias cn="cargo new"
alias ct="cargo test"
alias cr="cargo run"
alias cb="cargo build"
alias ccl="cargo clean"

alias vim="nvim"
alias vi="nvim"
alias cim="nvim"

alias vf="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim"

alias ls='lsd'

alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

gccf() {
    gcc -std=c99 -pedantic -Werror -Wall -Wextra -Wvla -fsanitize=address -g -o "out" "$@"
}

gacp() {
  echo "\n---add---\n"
  git add *
  echo "\n---commit---\n"
  git commit -m "$1"
  echo "\n---push---\n"
  git push
}

eval "$(starship init zsh)"

[ -f "/home/asq/.ghcup/env" ] && source "/home/asq/.ghcup/env" # ghcup-env
