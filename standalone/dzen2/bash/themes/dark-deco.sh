#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel parameters

bgcolor=$colBlack
fgcolor=$colWhite
alignment="l"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

#plain
separator="^bg()^fg($colWhite)|^bg()^fg()"

preIcon="^fg($colYellow500)$FontAwesome"
postIcon="^fn()^fg()"
labelColor="^fg($colGrey700)"
valueColor="^fg($colGrey300)"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

theme_show() {
    local text=""

    text+="^bg($colBlack)^fg($colBlue600)$deco_da_l"
    text+="^bg($colBlue600)$segmentVolume "
    text+="^bg($colBlack)^fg($colBlue600)$deco_da_r"
    text+="^bg($colBlack) $segmentCPU "
    text+="^bg($colBlack)^fg($colBlue400)$deco_da_l"
    text+="^bg($colBlue400)$segmentMemory "
    text+="^bg($colBlack)^fg($colBlue400)$deco_da_r"
    text+="^bg($colBlack) $segmentDisk "
    text+="^bg($colBlack)^fg($colBlue600)$deco_da_l"
    text+="^bg($colBlue600)$segmentSSID "
    text+="^bg($colBlack)^fg($colBlue600)$deco_da_r"
    text+="^bg($colBlack) $segmentNet "
  # text+="^bg($colBlack)^fg($colBlue800)$deco_da_l"
  # text+=" $segmentUptime "     
  # text+=" $segmentHost "
  # text+=" $segmentUpdates "
  # text+=" $segmentDate "  
  # text+=" $segmentMPD "
    text+=" "
    
    echo -n $text
}
