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
   xpos=${geometry[0]}
   ypos=${geometry[3]}-$panel_height
   width=${geometry[2]}
   height=$panel_height
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# lemonbar Parameters

function get_lemon_parameters() {  
    # parameter: function argument
    local monitor=$1
    local panel_height=$2

    # calculate geometry
    get_geometry $monitor
    get_top_panel_geometry $panel_height "${geometry[@]}"
    
    # geometry: -g widthxheight+x+y
    geom_res="${width}x${height}+${xpos}+${ypos}"
    
    # color, with transparency
    local bgcolor="#aa000000"
    local fgcolor="#ffffff"
    
    # XFT: require lemonbar_xft_git 
    local font_takaop="takaopgothic-9"
    local font_bottom="monospace-9"
    local font_symbol="PowerlineSymbols-11"
    local font_awesome="FontAwesome-9"

    # finally
    lemon_parameters="  -g $geom_res -u 2"
    lemon_parameters+=" -B $bgcolor -F $fgcolor" 
    lemon_parameters+=" -f $font_takaop -f $font_awesome -f $font_symbol" 
}
