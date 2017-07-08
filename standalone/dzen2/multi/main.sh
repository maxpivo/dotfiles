#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# parameters for 1280 width screen

width_side=400
width_center=480
height=24

xpos_topleft=0
ypos_topleft=0

xpos_topcenter=400
ypos_topcenter=0

xpos_topright=880
ypos_topright=0

xpos_bottomleft=0
ypos_bottomleft=(800-24)

xpos_bottomcenter=400
ypos_bottomcenter=(800-24)

xpos_bottomright=880
ypos_bottomright=(800-24)

bgcolor="#ffffff"
fgcolor="#000000"

font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"

parameters_topleft="  -x $xpos_topleft -y $ypos_topleft" 
parameters_topleft+="  -w $width_side -h $height" 
parameters_topleft+=" -fn $font"
parameters_topleft+=" -ta l -bg $bgcolor -fg $fgcolor"
parameters_topleft+=" -title-name dzentopleft"

parameters_topcenter="  -x $xpos_topcenter -y $ypos_topcenter" 
parameters_topcenter+="  -w $width_center -h $height" 
parameters_topcenter+=" -fn $font"
parameters_topcenter+=" -ta c -bg $bgcolor -fg $fgcolor"
parameters_topcenter+=" -title-name dzentopcenter"

parameters_topright="  -x $xpos_topright -y $ypos_topright" 
parameters_topright+="  -w $width_side -h $height" 
parameters_topright+=" -fn $font"
parameters_topright+=" -ta r -bg $bgcolor -fg $fgcolor"
parameters_topright+=" -title-name dzentopright"

parameters_bottomleft="  -x $xpos_bottomleft -y $ypos_bottomleft" 
parameters_bottomleft+="  -w $width_side -h $height" 
parameters_bottomleft+=" -fn $font"
parameters_bottomleft+=" -ta l -bg $bgcolor -fg $fgcolor"
parameters_bottomleft+=" -title-name dzenbottomleft"

parameters_bottomcenter="  -x $xpos_bottomcenter -y $ypos_bottomcenter" 
parameters_bottomcenter+="  -w $width_center -h $height" 
parameters_bottomcenter+=" -fn $font"
parameters_bottomcenter+=" -ta c -bg $bgcolor -fg $fgcolor"
parameters_bottomcenter+=" -title-name dzenbottomcenter"

parameters_bottomright="  -x $xpos_bottomright -y $ypos_bottomright" 
parameters_bottomright+="  -w $width_side -h $height" 
parameters_bottomright+=" -fn $font"
parameters_bottomright+=" -ta r -bg $bgcolor -fg $fgcolor"
parameters_bottomright+=" -title-name dzenbottomright"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all dzen2 instance
pkill dzen2

# This is just a sample.
# more dzen-conky means more CPU.

path=$(dirname "$0")

# execute dzen
conky -c $path/conky-topleft.lua      | dzen2 $parameters_topleft &
conky -c $path/conky-topcenter.lua    | dzen2 $parameters_topcenter &
conky -c $path/conky-topright.lua     | dzen2 $parameters_topright &
conky -c $path/conky-bottomleft.lua   | dzen2 $parameters_bottomleft &
conky -c $path/conky-bottomcenter.lua | dzen2 $parameters_bottomcenter &
conky -c $path/conky-bottomright.lua  | dzen2 $parameters_bottomright &

# optional transparency
sleep 1 && exec `(transset .8 -n dzentopleft      >/dev/null 2>&1 &)` & 
sleep 1 && exec `(transset .8 -n dzentopcenter    >/dev/null 2>&1 &)` & 
sleep 1 && exec `(transset .8 -n dzentopright     >/dev/null 2>&1 &)` & 
sleep 1 && exec `(transset .8 -n dzenbottomleft   >/dev/null 2>&1 &)` & 
sleep 1 && exec `(transset .8 -n dzenbottomcenter >/dev/null 2>&1 &)` & 
sleep 1 && exec `(transset .8 -n dzenbottomright  >/dev/null 2>&1 &)` & 



