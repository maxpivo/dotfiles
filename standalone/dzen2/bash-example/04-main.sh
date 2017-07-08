#!/usr/bin/env bash

# remove all dzen2 instance
pkill dzen2

# include
DIR=$(dirname "$0")
. ${DIR}/04-output.sh

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



