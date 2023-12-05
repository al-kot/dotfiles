
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
if [ $HOME = "/home/pipa" ]; then 
    export HOME="/mnt/psf/Home"
    cd
fi

export ZSH="$HOME/.oh-my-zsh"
# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="heapbytes" # set by `omz`
# SOLARIZED_THEME="dark"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
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

# htpup() {
#     cd /home/pipa
#     rm -rf /home/pipa/epita-ing-assistants-acu-myhttpd-2026-aleksei.kotliarov
#     cp -r /mnt/psf/Home/epita-ing-assistants-acu-myhttpd-2026-aleksei.kotliarov /home/pipa/
#     cd /home/pipa/epita-ing-assistants-acu-myhttpd-2026-aleksei.kotliarov/httpd
# }

gccf() {
    gcc -std=c99 -pedantic -Werror -Wall -Wextra -Wvla -fsanitize=address -g -o "out" "$@"
}



gtt() {
    echo "\n---add---\n"
    git add *
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

lik() {
    MallocStackLogging=YES leaks -q --atExit -- $1 > tmp
    clear
    cat tmp
    rm tmp
}

intdb() {
    rm -rf "$HOME/atl_sql"
    initdb --locale "$LANG" -E UTF8
}

mkdb() {
    createuser -s postgres
    createdb -U postgres roger_roger
    pg_restore -U postgres -O -d roger_roger roger_roger.dump
}

mntafs() {
    diskutil unmount force "$HOME/afs"
    rm -rf "afs"
    mkdir -p "afs"
    kinit -f "aleksei.kotliarov@CRI.EPITA.FR"
    sshfs -o reconnect "aleksei.kotliarov@ssh.cri.epita.fr:/afs/cri.epita.fr/user/a/al/aleksei.kotliarov/u/" "afs"
}

export PGDATA="$HOME/atl_sql/postgres_data"
export PGHOST="/tmp"

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
