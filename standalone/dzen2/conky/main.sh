#!/usr/bin/env bash

generated_output() {
    conky -c ~/Documents/standalone/dzen2/conky/conky.lua
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# parameters

xpos=0
ypos=0
width=640
height=24

bgcolor="#000000"
fgcolor="#ffffff"

# bgcolor="#ffffff"
# fgcolor="#000000"

font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"

parameters="  -x $xpos -y $ypos -w $width -h $height" 
parameters+=" -fn $font"
parameters+=" -ta c -bg $bgcolor -fg $fgcolor"
parameters+=" -title-name dzentop"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all dzen2 instance
pkill dzen2

# execute dzen
generated_output | dzen2 $parameters &

# optional transparency
sleep 1 && exec `(transset .8 -n dzentop >/dev/null 2>&1 &)` & 



