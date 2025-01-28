#!/bin/bash
get_git_status() {
  CURRENT_DIR=$(tmux display-message -p "#{pane_current_path}")
  WINDOW_NAME=$(tmux display-message -p '#W' | xargs)
  ZOOMED=$(tmux display-message -p "#{window_zoomed_flag}")

  ZOOM_STATUS=""
  if [ "$ZOOMED" -eq 1 ]; then
    ZOOM_STATUS=" #[fg=#8a8c95]󰘖 zoom #[fg=#8a8c95] "
  fi

  if [ "$WINDOW_NAME" = "ssh" ]; then
    IP=$(ps -t $(tmux display-message -p '#{pane_tty}') | grep ssh | awk '{print $5}' | tr -d '()')
    echo " $ZOOM_STATUS #[fg=#8a8c95] $WINDOW_NAME #[fg=#F0C674]$IP #[fg=#8a8c95] "

  elif [ "$WINDOW_NAME" = "docker" ]; then
    echo " $ZOOM_STATUS #[fg=#8a8c95]󰡨 $WINDOW_NAME $HOST_PID "

  elif [ "$WINDOW_NAME" = "ftp" ] || [ "$WINDOW_NAME" = "gftp" ]; then
    echo " $ZOOM_STATUS #[fg=#8a8c95] ftp "

  elif [ "$WINDOW_NAME" = "tmux" ] || [ "$WINDOW_NAME" = "[tmux]" ]; then
    echo " $ZOOM_STATUS #[fg=#8a8c95] tmux "

  elif [ -d "$CURRENT_DIR/.git" ]; then
    echo " $ZOOM_STATUS #[fg=#8a8c95] git "

  elif [ "$WINDOW_NAME" = "nvim" ]; then
    echo " $ZOOM_STATUS #[fg=#8a8c95] $WINDOW_NAME "

  elif [ "$WINDOW_NAME" = "sudo" ]; then
    WINDOW_PANE_PID=$(tmux display-message -p "#{pane_pid}")
    RUNNING_PROCESS=$(ps -o comm,etime= -p "$WINDOW_PANE_PID" | awk 'NR==2 {gsub(/^-/, ""); sub(/:[0-9]{2}$/, ""); print}')
    echo " $ZOOM_STATUS #[fg=#8a8c95] $RUNNING_PROCESS "

  else
    echo " $ZOOM_STATUS #[fg=#8a8c95] $WINDOW_NAME "
  fi
}

get_git_status