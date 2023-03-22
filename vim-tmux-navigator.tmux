#!/usr/bin/env bash

version_pat='s/^tmux[^0-9]*([.0-9]+).*/\1/p'

is_vim="ps -o state= -o comm= -t '#{pane_tty}' | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?)(diff)?$'"

tmux bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h' 'if-shell -F "#{pane_at_left}"   "" "select-pane -L "'
tmux bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j' 'if-shell -F "#{pane_at_bottom}" "" "select-pane -D "'
tmux bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k' 'if-shell -F "#{pane_at_top}"    "" "select-pane -U "'
tmux bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l' 'if-shell -F "#{pane_at_right}"  "" "select-pane -R "'

tmux_version="$(tmux -V | sed -En "$version_pat")"
tmux setenv -g tmux_version "$tmux_version"

tmux if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
  "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
tmux if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
  "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

tmux bind-key -T copy-mode-vi 'C-h' if-shell -F '#{pane_at_left}'   '' 'select-pane -L'
tmux bind-key -T copy-mode-vi 'C-j' if-shell -F '#{pane_at_bottom}' '' 'select-pane -D'
tmux bind-key -T copy-mode-vi 'C-k' if-shell -F '#{pane_at_top}'    '' 'select-pane -U'
tmux bind-key -T copy-mode-vi 'C-l' if-shell -F '#{pane_at_right}'  '' 'select-pane -R'
