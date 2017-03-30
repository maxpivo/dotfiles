#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# load on startup

  # non windowed app
    compton &
    dunst &
    parcellite &
    nitrogen --restore &
    mpd &
    
  # windowed app
    xfce4-terminal &
    sleep 1 && firefox &
    sleep 2 && geany &
    sleep 2 && thunar &

