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


gtt() {
    echo "\n---add---\n"
    git add -u
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

gccl() {
    gccf $@
    lik "./out"
}



mntafs() {
    diskutil unmount force "$HOME/afs"
    rm -rf "afs"
    mkdir -p "afs"
    kinit -f "aleksei.kotliarov@CRI.EPITA.FR"
    sshfs -o reconnect "aleksei.kotliarov@ssh.cri.epita.fr:/afs/cri.epita.fr/user/a/al/aleksei.kotliarov/u/" "afs"
}


case `uname` in
    Darwin)
        # commands for OS X go here
        export PATH=/usr/local/bin:$PATH
        export MAGICK_HOME=/opt/homebrew/opt/imagemagick/
        export PATH="/opt/homebrew/opt/imagemagick/bin:$PATH"
        export PATH="/opt/homebrew/include:$PATH"
        export PATH="/opt/homebrew/Cellar/ffmpeg/5.1.2_6/include:$PATH"
        export PATH="/opt/homebrew/include:${PATH:+:${PATH}}"
        export PATH="/opt/homebrew/opt/clang-build-analyzer/bin:$PATH"
        export PATH="/opt/homebrew/opt/cmake/bin:$PATH"
        export PATH="/opt/homebrew/Cellar/clang-build-analyzer/1.5.0/bin:${PATH:+:${PATH}}"
        export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
        export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
        export CPATH="/opt/homebrew/include"
        export LIBRARY_PATH="/opt/homebrew/lib" 
        export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
        ;;
    Linux)
        # commands for Linux go here
        ;;
    FreeBSD)
        # commands for FreeBSD go here
        ;;
esac

eval "$(starship init zsh)"
