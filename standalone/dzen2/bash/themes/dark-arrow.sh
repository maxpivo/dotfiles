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

    text+=" ^bg($colBlue200)^fg($colBlack)$right_hard_arrow"
    text+=" $segmentVolume "
    text+=" ^bg($colBlack)^fg($colBlue200)$right_hard_arrow"
    text+=" $segmentCPU "
    text+=" ^bg($colBlue400)^fg($colBlack)$right_hard_arrow"
    text+=" $segmentMemory "
    text+=" ^bg($colBlack)^fg($colBlue400)$right_hard_arrow"
    text+=" $segmentDisk "
    text+=" ^bg($colBlue600)^fg($colBlack)$right_hard_arrow"
    text+=" $segmentSSID "
    text+=" ^bg($colBlack)^fg($colBlue600)$right_hard_arrow"
    text+=" $segmentNet "
    text+=" ^bg($colBlue800)^fg($colBlack)$right_hard_arrow"
  # text+=" $segmentUptime "     
  # text+=" $segmentHost "
  # text+=" $segmentUpdates "
  # text+=" $segmentDate "  
  # text+=" $segmentMPD "
    text+=" ^bg($colBlue900)^fg($colBlue800)$right_hard_arrow"
    text+=" "
    text+=" ^bg($colBlack)^fg($colBlue900)$right_hard_arrow"
    
    echo -n $text
}
