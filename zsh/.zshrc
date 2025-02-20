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

# === fzf ===
alias vf="fd --type f --hidden --exclude .git | fzf-tmux -p --reverse | xargs nvim"
fg="#D8CAAC"
bg="#1F1F28"
bg_highlight="#505A60"
purple="#D39BB6"
blue="#83B6AF"
cyan="#87C095"
grey="#868D80"

export FZF_DEFAULT_OPTS="--color=fg:-1,bg:-1,hl:${purple},fg+:${fg} \
                        --color=bg+:${bg_highlight},hl+:${purple},info:${blue} \
                        --color=prompt:${cyan},pointer:${cyan},marker:${cyan} \
                        --color=spinner:${cyan},header:${cyan},gutter:${bg} \
                        --padding=\"1\" \
                        --prompt=\"> \" \
                        --marker=\">\" \
                        --pointer=\"◆\" \
                        --separator=\"-\" \
                        --scrollbar=\"│\" \
                        --layout=\"reverse\" \
                        --info=\"right\""

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}


alias ls='lsd'

alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
alias lt='ls --tree'

tmn() {
    SHELL=$(which zsh) tmux new -s "$1"
}

export SCHOOL=true

alias lg='lazygit'

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
