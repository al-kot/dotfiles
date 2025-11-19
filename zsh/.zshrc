bindkey -e

setopt share_history

# === fzf ===
color00="#32302f"
color01="#3c3836"
color02="#504945"
color03="#665c54"
color04="#bdae93"
color05="#d5c4a1"
color06="#ebdbb2"
color07="#fbf1c7"
color08="#fb4934"
color09="#fe8019"
color0A="#fabd2f"
color0B="#b8bb26"
color0C="#8ec07c"
color0D="#83a598"
color0E="#d3869b"
color0F="#d65d0e"

export FZF_DEFAULT_OPTS="--color=bg+:$color01,bg:-1,spinner:$color0C,hl:$color0D \
                        --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C \
                        --color=fg+:$color06,prompt:$color0A,hl+:$color0D,gutter:-1 \
                        --padding=\"1\" \
                        --prompt=\"> \" \
                        --marker=\">\" \
                        --separator=\"-\" \
                        --scrollbar=\"│\" \
                        --layout=\"reverse\" \
                        --info=\"right\" \
                        --border=none \
                        --height 50%"

export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

_fzf_compgen_path() {
  fd --hidden --exclude .git . "$1"
}

_fzf_compgen_dir() {
  fd --type=d --hidden --exclude .git . "$1"
}

source "$HOME/fzf-git.sh"

gsb() {
    _fzf_git_branches | xargs git switch
}

gcb() {
    _fzf_git_branches | xargs git checkout
}
mkenv() {
    [ "$1" = "" ] && { echo 'provide a name'; return }
    [ -d "$HOME/.virtualenvs" ] || mkdir "$HOME/.virtualenvs"
    python3 -m venv "$HOME/.virtualenvs/$1"
    # source venv/bin/activate
}

mkkern() {
    pip install ipykernel
    python -m ipykernel install --user --name="$1"
}

vnv() {
    [ -d "$HOME/.virtualenvs" ] || mkdir "$HOME/.virtualenvs"
    name="$(ls "$HOME/.virtualenvs" | fzf --print-query | tail -1)"
    [ "$name" = "" ] && return
    [ -d "$HOME/.virtualenvs/$name" ] || python3 -m venv "$HOME/.virtualenvs/$name"
}

vnva() {
    [ -d "$HOME/.virtualenvs" ] || mkdir "$HOME/.virtualenvs"
    name="$(ls "$HOME/.virtualenvs" | fzf --print-query | tail -1)"
    [ "$name" = "" ] && return
    [ -d "$HOME/.virtualenvs/$name" ] || $1 -m venv "$HOME/.virtualenvs/$name"
    source "$HOME/.virtualenvs/$name/bin/activate"
}

vnva311() {
    [ -d "$HOME/.virtualenvs" ] || mkdir "$HOME/.virtualenvs"
    name="$(ls "$HOME/.virtualenvs" | fzf --print-query | tail -1)"
    [ "$name" = "" ] && return
    [ -d "$HOME/.virtualenvs/$name" ] || python3.11 -m venv "$HOME/.virtualenvs/$name"
    source "$HOME/.virtualenvs/$name/bin/activate"
}

m() {
    make DIR=$1
    ./$1/a.out
}
mc() {
    make clean DIR=$1
}

jupyinit() {
    pip install pynvim jupyter_client cairosvg plotly kaleido pnglatex pyperclip
}

# === env vars ===
export PATH=$HOME/.local/bin:$PATH
export PATH=$HOME/.cargo/bin:$PATH
reset_cursor.sh

case `uname` in
    Darwin)
        export PATH=/usr/local/bin:$PATH
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
        export LDLIBS="-L/opt/homebrew/lib"
        export LIBRARY_PATH="/opt/homebrew/lib" 
        export CPPFLAGS="-I/opt/homebrew/opt/llvm/include -I/opt/homebrew/include"
        # export CFLAGS="-I/opt/homebrew/include"
        export CPATH="/opt/homebrew/include"
        ;;
    Linux)
        export PATH=/opt/cuda/bin:$PATH
        ;;
esac

export PATH="$HOME/go/bin:$PATH"

# === plugins ===

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

plug="$HOME/.zsh/zsh-completions"
if [ ! -d "$plug" ]; then
    git clone https://github.com/zsh-users/zsh-completions.git "$HOME/.zsh/zsh-completions"
fi
fpath=($HOME/.zsh/zsh-completions $fpath)

# === evals ===

eval "$(starship init zsh)"
eval "$(fzf --zsh)"

# === aliases ===

alias vim="nvim"
alias vi="nvim"
alias cim="nvim"

alias ll='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias lt='lsd --tree -I node_modules'

alias lg='lazygit'

alias vf="fd --type f --hidden --exclude .git --exclude '*.pyc' --exclude node_modules --exclude venv | fzf --reverse | xargs nvim"
alias rtfm="tldr --list | fzf --reverse | xargs tldr"

export BAT_THEME='gruvbox-dark'

zstyle :compinstall filename "$HOME/.zshrc"

fpath=($HOME/.docker/completions $fpath)
autoload -Uz compinit
compinit

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=1000000000
export SAVEHIST=1000000000
setopt EXTENDED_HISTORY

fastfetch

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/alekseikotliarov/.lmstudio/bin"
# End of LM Studio CLI section

