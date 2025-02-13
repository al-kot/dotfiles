source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

bindkey -e

alias gc="git commit -m"
alias ga="git add *"
alias gp="git push"
alias gs="git status"

alias vim="nvim"
alias vi="nvim"
alias cim="nvim"

alias vf="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim"

alias ls='lsd'

alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

alias tmn="SHELL=$(which zsh) tmux new -s pipi"

gccf() {
    gcc -std=c99 -pedantic -Werror -Wall -Wextra -Wvla -fsanitize=address -g -o "out" "$@"
}

gcpp() {
    g++ -Wall -Wextra -Werror -pedantic -std=c++20 -Wold-style-cast -o "out" "$@"
}

gtt() {
    # echo "\n---add---\n"
    # git add *
    echo "\n---commit---\n"
    git commit -m "gg"
    echo "\n---tag---\n"
    git tag -a "$1" -m "gg"
    echo "\n---push---\n"
    git push --follow-tags origin master
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
