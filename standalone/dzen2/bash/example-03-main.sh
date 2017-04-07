#!/usr/bin/env bash

# include
. ~/Documents/standalone/dzen2/bash/example-03-output.sh

# dzen2

xpos=0
ypos=0
width=640
height=24
fgcolor=$colBlack
bgcolor=$colWhite
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"

parameters="  -x $xpos -y $ypos -w $width -h $height" 
parameters+=" -fn $font"
parameters+=" -ta c -bg $bgcolor -fg $fgcolor"
parameters+=" -title-name dzentop"

generated_output | dzen2 $parameters &

sleep 1 && exec `(transset-df .8 -n dzentop >/dev/null 2>&1 &)` &



