#!/usr/bin/env bash

# this is a simple config for herbstluftwm

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----


hc() {
    # http://www.thegeekstuff.com/2010/05/bash-shell-special-parameters/
    herbstclient "$@"
}

# I don't know what it means
#        emit_hook ARGS ...
#           Emits a custom hook to all idling herbstclients.
hc emit_hook reload

xsetroot -solid '#5A8E3A'

# gap counter
echo 35 > /tmp/herbstluftwm-gap

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# helpers

. ~/.config/herbstluftwm/bash/helper.sh

hlc_keybindings

hlc_tags

hlc_theme

hlc_rules

# deprecated, use nitrogen instead
# hlc_feh_wallpaper

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# unlock, just to be sure

hc unlock

# hc set tree_style '╾│ ├└╼─┐'
hc set tree_style '⊙│ ├╰»─╮'

# do multi monitor setup here, e.g.:
# hc set_monitors 1280x1024+0+0 1280x1024+1280+0
# or simply:
# hc detect_monitors

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# find the panel

panel=~/.config/herbstluftwm/bash/dzen2/panel.sh
[ -x "$panel" ] || panel=/etc/xdg/herbstluftwm/panel.sh
for monitor in $(herbstclient list_monitors | cut -d: -f1) ; do
    # start it on each monitor
    "$panel" $monitor &
done

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# $ man herbstluftwm

hc lock

# tag number 5
hc floating 5 on

hc unlock

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# load on startup

if hc silent new_attr bool my_not_first_autostart ; then

  # non windowed app
    compton &
    dunst &
    parcellite &
    nitrogen --restore &
    
  # windowed app
    xfce4-terminal &
    firefox &
    geany &
    thunar &
fi

