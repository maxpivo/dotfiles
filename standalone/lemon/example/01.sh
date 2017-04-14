#!/usr/bin/env bash

colWhite='ffffff'
colBlack='000000'

generated_output() {
    homeicon_awesome='\uf015' 
    timeicon_siji='\ue018'  

    # endless loop
    while true; do 
      echo -en " $homeicon_awesome "
      echo -en " $timeicon_siji "
      date +'%a %b %d %H:%M:%S'
      sleep 1
    done
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# parameters

# settings
position="640x24+0+0"
background="#aa$colWhite"
foreground="#ff$colBlack"

# XLFD
font_fixed='-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*'
font_siji='-wuncon-siji-medium-r-normal--10-100-75-75-c-80-iso10646-1'
font_awesome='-*-fontawesome-medium-*-*-*-17-*-*-*-*-*-*-*'

# https://wiki.archlinux.org/index.php/Lemonbar
# https://github.com/LemonBoy/bar
generated_output | lemonbar \
    -g $position -u 2 -B $background -F $foreground \
    -f $font_fixed -f $font_awesome -f $font_siji
