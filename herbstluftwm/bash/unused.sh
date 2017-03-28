#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# variables

# terminal=urxvt
# emacs=$HOME/bin/emet
# file_manager=$HOME/bin/ranger_spawn.sh
# browser=firefox
# alternate_browser=chromium

# epsi
# close tray if reloading
# killall stalonetray

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# wallpaper

# deprecated, use nitrogen instead
hlc_feh_wallpaper() {
    wp_path="/media/Works/Sosial/2016 - inkscape/Material/" 
    wp_file_2="isometric-06/paper (06) - isometric.png" 
    wp_file="paper-01/paper (02b).png" 
    wallpaper="$wp_path$wp_file"
    feh --bg-scale "$wallpaper"
}
