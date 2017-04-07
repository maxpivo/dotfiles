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

    text+=" ^bg($colRed200)^fg($colRed100)$right_hard_arrow"
    text+=" $segmentVolume "
    text+=" ^bg($colRed300)^fg($colRed200)$right_hard_arrow"
    text+=" $segmentCPU "
    text+=" ^bg($colRed400)^fg($colRed300)$right_hard_arrow"
    text+=" $segmentMemory "
    text+=" ^bg($colRed500)^fg($colRed400)$right_hard_arrow"
    text+=" $segmentDisk "
    text+=" ^bg($colRed600)^fg($colRed500)$right_hard_arrow"
    text+=" $segmentSSID "
    text+=" ^bg($colRed700)^fg($colRed600)$right_hard_arrow"
    text+=" $segmentNet "
    text+=" ^bg($colRed800)^fg($colRed700)$right_hard_arrow"
  # text+=" $segmentUptime "     
  # text+=" $segmentHost "
  # text+=" $segmentUpdates "
  # text+=" $segmentDate "  
  # text+=" $segmentMPD "
    text+=" ^bg($colWhite)^fg($colRed900)$right_hard_arrow"
    text+=" "
    
    echo -n $text
}
