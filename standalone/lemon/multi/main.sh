#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# parameters

# settings
position_top="1280x24+0+0"
position_bottom="1280x24+0+776"
background="#aaffffff"
foreground="#ff000000"

# XFT
# require lemonbar_xft_git 
font_symbol="PowerlineSymbols-9"
font_awesome="FontAwesome-9"
font_monospace="monospace-9"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all lemonbar instance
pkill lemonbar

path=$(dirname "$0")

conky -c $path/conky-top.lua | lemonbar \
    -g $position_top -u 2 -B $background -F $foreground \
    -f $font_monospace -f $font_awesome -f $font_symbol &
    
conky -c $path/conky-bottom.lua | lemonbar \
    -g $position_bottom -u 2 -B $background -F $foreground \
    -f $font_monospace -f $font_awesome -f $font_symbol &
    
