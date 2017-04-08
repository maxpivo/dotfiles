#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel parameters

bgcolor=$colWhite
fgcolor=$colBlack
alignment="l"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

#plain
separator="^bg()^fg($colBlack)|^bg()^fg()"

preIcon="^fg($colYellow500)$FontAwesome"
postIcon="^fn()^fg()"
labelColor="^fg($colGrey300)"
valueColor="^fg($colGrey900)"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

theme_show() {
    local text=""

    text+=" ^bg($colRed200)^fg($colRed100)$deco_dc_tl"
    text+=" $segmentVolume "
    text+=" ^bg($colRed300)^fg($colRed200)$deco_dc_tl"
    text+=" $segmentCPU "
    text+=" ^bg($colRed400)^fg($colRed300)$deco_dc_tl"
    text+=" $segmentMemory "
    text+=" ^bg($colRed500)^fg($colRed400)$deco_dc_tl"
    text+=" $segmentDisk "
    text+=" ^bg($colRed600)^fg($colRed500)$deco_dc_tl"
    text+=" $segmentSSID "
    text+=" ^bg($colRed700)^fg($colRed600)$deco_dc_tl"
    text+=" $segmentNet "
    text+=" ^bg($colRed800)^fg($colRed700)$deco_dc_tl"
  # text+=" $segmentUptime "     
  # text+=" $segmentHost "
  # text+=" $segmentUpdates "
  # text+=" $segmentDate "  
  # text+=" $segmentMPD "
    text+=" ^bg($colRed900)^fg($colRed800)$deco_dc_tl"
    text+=" "
    text+=" ^bg($colWhite)^fg($colRed900)$deco_dc_tl"
    
    echo -n $text
}
