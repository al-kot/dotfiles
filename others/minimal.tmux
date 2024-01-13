#!/usr/bin/env bash

get_tmux_option() {
	local option=$1
	local default_value="$2"
	local option_value=$(tmux show-options -gqv "$option")
	if [ -n "$option_value" ]; then
		echo "$option_value"
		return
	fi
	echo "$default_value"
}

bg=$(get_tmux_option "@minimal-tmux-bg" '#698DDA')
status=$(get_tmux_option "@minimal-tmux-status" "bottom")
justify=$(get_tmux_option "@minimal-tmux-justify" "centre")
indicator_state=$(get_tmux_option "@minimal-tmux-indicator" true)
if [ "$indicator_state" = true ]; then
	indicator=$(get_tmux_option "@minimal-tmux-indicator-str" "  tmux  ")
else
	indicator=""
fi

# tmux set-option -g status-position "${status}"
# tmux set-option -g status-style bg=default,fg=default
# tmux set-option -g status-justify "${justify}"
# tmux set-option -g status-left "#[bg=default,fg=default,bold]#{?client_prefix,,${indicator}}#[bg=${bg},fg=black,bold]#{?client_prefix,${indicator},}"
# tmux set-option -g status-right "#S"
# tmux set-option -g window-status-format " #I:#W "
# tmux set-option -g window-status-current-format "#[bg=${bg},fg=#000000] #I:#W#{?window_zoomed_flag, 󰊓 , }"

tmux set-option -g status-position "bottom"
tmux set -g pane-active-border-style fg=#bb9af7
tmux set -g pane-border-style fg=#5a4a78
tmux set -g pane-border-lines double
tmux set -g pane-border-indicators arrows
tmux set -g window-active-style bg=terminal
tmux set -g window-style bg=terminal
tmux set-option -g status-style bg=terminal,fg=#bb9af7
tmux set-option -g status-justify centre
tmux set-option -g status-left '#[bg=#7aa2f8,fg=black,bold]#{?client_prefix,,   }#[bg=green,fg=black,bold]#{?client_prefix,   ,}'
tmux set-option -g status-right '#[bg=#f7768e,fg=black,bold] #S '
tmux set-option -g window-status-format '#[bg=#5a4a78,fg=black] #W '
tmux set-option -g window-status-current-format '#[bg=#bb9af7,fg=black] #W#{?window_zoomed_flag,  , }'
