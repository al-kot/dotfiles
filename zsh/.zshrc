bindkey -e

setopt share_history

alias lg="lazygit"

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
color00='#32302f'
color01='#3c3836'
color02='#504945'
color03='#665c54'
color04='#bdae93'
color05='#d5c4a1'
color06='#ebdbb2'
color07='#fbf1c7'
color08='#fb4934'
color09='#fe8019'
color0A='#fabd2f'
color0B='#b8bb26'
color0C='#8ec07c'
color0D='#83a598'
color0E='#d3869b'
color0F='#d65d0e'

export FZF_DEFAULT_OPTS="--color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D \
                        --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C \
                        --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D \
                        --padding=\"1\" \
                        --prompt=\"> \" \
                        --marker=\">\" \
                        --pointer=\"◆\" \
                        --separator=\"-\" \
                        --scrollbar=\"│\" \
                        --layout=\"reverse\" \
                        --info=\"right\" \
                        --border \
                        --height 50% --tmux center,50%"

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

plug="$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
if [ ! -f "$plug" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.zsh/zsh-autosuggestions"
fi
source "$plug"

plug="$HOME/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
if [ ! -f "$plug" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.zsh/zsh-syntax-highlighting"
fi
source "$plug"
