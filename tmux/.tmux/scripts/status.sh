#!/bin/bash
get_git_status() {
  CURRENT_DIR=$(tmux display-message -p "#{pane_current_path}")

  WINDOW_NAME=$(tmux display-message -p '#W' | xargs)

  if [ "$WINDOW_NAME" = "ssh" ]; then
    IP=$(ps -t $(tmux display-message -p '#{pane_tty}') | grep ssh | awk '{print $5}' | tr -d '()')
    echo " #[fg=#8a8c95]$WINDOW_NAME #[fg=#F0C674]$IP #[fg=#8a8c95] "

  elif [ "$WINDOW_NAME" = "docker" ]; then
    echo " #[fg=#8a8c95]$WINDOW_NAME 󰡨 "

  elif [ "$WINDOW_NAME" = "ftp" ] || [ "$WINDOW_NAME" = "gftp" ]; then
    echo " #[fg=#8a8c95]ftp  "

  elif [ "$WINDOW_NAME" = "tmux" ] || [ "$WINDOW_NAME" = "[tmux]" ]; then
    echo " #[fg=#8a8c95]tmux  "

  elif [ -d "$CURRENT_DIR/.git" ]; then
    echo " #[fg=#8a8c95]git  "

  elif [ "$WINDOW_NAME" = "nvim" ]; then
    echo " #[fg=#8a8c95]$WINDOW_NAME  "

  else
    echo " #[fg=#8a8c95]$WINDOW_NAME  "
  fi
}

get_git_status