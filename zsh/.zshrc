bindkey -e

export EDITOR='nvim'
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

setopt share_history

kanagawa_dragon_fzf="--highlight-line --info=inline-right --ansi --layout=reverse --border=sharp --style=full \
--color=border:#625e5a,fg:#c5c9c5,gutter:#1d1c19 \
--color=header:#c4746e,hl+:#c4b28a,hl:#c4b28a,info:#7a8382,marker:#87a987 \
--color=pointer:#8ba4b0,prompt:#8992a7,query:#c5c9c5:regular,scrollbar:#625e5a \
--color=separator:#625e5a,spinner:#b6927b"

export FZF_DEFAULT_OPTS="$kanagawa_dragon_fzf \
                        --padding=\"1\" \
                        --prompt=\"> \" \
                        --marker=\">\" \
                        --separator=\"-\" \
                        --scrollbar=\"│\" \
                        --layout=\"reverse\" \
                        --info=\"right\" \
                        --border=none \
                        --height 50% \
                        --gutter=' '"

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
        export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
        export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
        ;;
    Linux)
        export PATH=/opt/cuda/bin:$PATH
        export PATH="/opt/postgresql17/bin:$PATH"
        export CUDACXX="/opt/cuda/bin/nvcc"
        export HOST_COMPILER="/usr/bin/g++-12"
        # export PATH="/usr/lib/gcc/x86_64-pc-linux-gnu/14.3.1:$PATH"
        export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
        export PATH="$HOME/.nvm/versions/node/v23.1.0/bin:$PATH"
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
# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
# type starship_zle-keymap-select >/dev/null || \
#   {
#     echo "Load starship"
#     eval "$(starship init zsh)"
#   }
eval "$(starship init zsh)"
eval "$(fzf --zsh)"

# === aliases ===

if [ "$(which nvim)" != "nvim not found" ]; then
    alias vim="nvim"
    alias vi="nvim"
    alias cim="nvim"
fi

eza_cmd="EZA_CONFIG_DIR=~/.config/eza eza --icons --hyperlink --git --time-style=relative --color-scale=age --show-symlinks"
alias ll="$eza_cmd -l"
alias la="$eza_cmd -a"
alias lla="$eza_cmd -la"
alias lt="$eza_cmd -Tla --ignore-glob='__pycache__|.git|node_modules'"

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

export PGDATA="$HOME/postgres_data"
export PGHOST="/tmp"

export QMK_HOME="$HOME/qmk"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use  # This loads nvm


# bun completions
[ -s "/home/asq/.bun/_bun" ] && source "/home/asq/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

precmd() { printf '\e[6 q'; }

if [[ $- =~ i ]] && [[ -z "$TMUX" ]] && [[ -n "$SSH_TTY" ]]; then;
    tmux a -s ssh_tmux || tmux new -s ssh_tmux
fi
