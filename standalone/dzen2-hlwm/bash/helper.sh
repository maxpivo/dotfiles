#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# helpers

# script arguments
function get_monitor() {
    local argument=("$@")
    local num_args=${#argument[@]}

    # ternary operator
    [[ $num_args > 0 ]] && monitor=${argument[0]} || monitor=0
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# geometry calculation

function get_geometry() {
    local monitor=$1;
    geometry=( $(herbstclient monitor_rect "$monitor") )
    if [ -z "$geometry" ] ;then
        echo "Invalid monitor $monitor"
        exit 1
    fi
}

function get_top_panel_geometry() {
   local panel_height=$1
   shift
   local geometry=("$@")
   
   # geometry has the format X Y W H
     xpos=${geometry[0]}
     ypos=${geometry[1]}
    width=${geometry[2]}
   height=$panel_height
}

function get_bottom_panel_geometry() {
   local panel_height=$1
   shift
   local geometry=("$@")
   
   # geometry has the format X Y W H
     xpos=$(( ${geometry[0]} + 0 ))
     ypos=$(( ${geometry[3]} - $panel_height ))
    width=$(( ${geometry[2]} - 0 ))
   height=$panel_height
}
# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen Parameters

function get_dzen2_parameters() {    
    local monitor=$1
    local panel_height=$2

    get_geometry $monitor
    get_top_panel_geometry $panel_height "${geometry[@]}"
    
    local bgcolor="#000000"
    local fgcolor="#ffffff"
    local font="-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*"

    dzen2_parameters="  -x $xpos -y $ypos -w $width -h $height" 
    dzen2_parameters+=" -ta l -bg $bgcolor -fg $fgcolor"
    dzen2_parameters+=" -title-name dzentop"
    dzen2_parameters+=" -fn $font"
}
