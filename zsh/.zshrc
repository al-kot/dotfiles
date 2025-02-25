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

alias l='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree'

alias colorgen='~/colorgen/gen_colors.py'

# === fzf ===
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
eval "$(fzf --zsh)"



export PATH=$PATH:$HOME/go/bin

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh


[ -f "/home/asq/.ghcup/env" ] && . "/home/asq/.ghcup/env" # ghcup-env