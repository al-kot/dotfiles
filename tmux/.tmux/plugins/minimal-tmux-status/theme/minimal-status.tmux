set-option -g status-position "bottom"
set -g pane-active-border-style fg=#bb9af7
set -g pane-border-style fg=#5a4a78
set -g pane-border-lines double
set -g pane-border-indicators arrows
set -g window-active-style bg=terminal
set -g window-style bg=terminal
set-option -g status-style bg=terminal,fg=#bb9af7
set-option -g status-justify centre
set-option -g status-left '#[bg=#7aa2f8,fg=black,bold]#{?client_prefix,,   }#[bg=green,fg=black,bold]#{?client_prefix,   ,}'
set-option -g status-right '#[bg=#f7768e,fg=black,bold] #S '
set-option -g window-status-format '#[bg=#5a4a78,fg=black] #W '
set-option -g window-status-current-format '#[bg=#bb9af7,fg=black] #W#{?window_zoomed_flag,  , }'
