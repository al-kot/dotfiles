#!/bin/zsh
# Generates SSH connection list and runs fzf, outputs selected connection
#set -euo pipefail

SSH_CONFIG="$HOME/.ssh/config"
[ -f "$HOME/.ssh/hosts" ] && SSH_CONFIG="$HOME/.ssh/hosts"
KNOWN_HOSTS="$HOME/.ssh/known_hosts"

hosts="$(awk '/^Host / && $2 != "*" {print $2}' "$SSH_CONFIG")"
fzf_inputs=""

for h in $=hosts; do
    user="$(ssh -G "$h" | grep '^user ' | awk '{print $2}')"
    hostname="$(ssh -G $h | grep '^hostname ' | awk '{print $2}')"
    inp="$h $user@$hostname"
    if [ -z "$fzf_inputs" ]; then
        fzf_inputs="$inp"
    else
        fzf_inputs="$fzf_inputs\n$inp"
    fi
done

selected=$(echo "$fzf_inputs" | fzf \
    --print-query \
    --height 80% \
    --layout=reverse \
    --border=none \
    --no-height \
    --preview-window=right:50%:wrap \
    --header-first --header '<alias> <user>@<ip>' \
    --prompt="> " | tail -1)

alias=$(echo "$selected" | awk '{print $1}')
conn=$(echo "$selected" | awk '{print $2}')

[ -z "$conn" ] || [ -z "$alias" ] && exit 0

if [ -z "$(tmux has-session -t ssh 2>&1)" ]; then
    tmux new-window -t ssh: -n "$alias" "ssh $conn"
else
    tmux new-session -d -s ssh -n "$alias" "ssh $conn"
fi

