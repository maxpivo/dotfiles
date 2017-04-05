#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel color

bgcolor=$colBlack
fgcolor=$colWhite

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

#plain
separator="^bg()^fg($colWhite)|^bg()^fg()"

preIcon="^fg($colYellow500)$FontAwesome"
postIcon="^fn()^fg()"
labelColor="^fg($colGrey900)"
valueColor="^fg($colGrey100)"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

theme_tagmark_pre() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg($colBlue500)^fg($colBlack)$right_hard_arrow"
             deco+="^bg($colBlue500)^fg($colWhite)"     
        ;;
        '+') deco="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco="^bg()^fg($colWhite)"                ;;
        '!') deco="^bg($colRed500)^fg($colWhite)"      ;;
        *)   deco="^bg()^fg($colGrey600)"              ;;
    esac
    
    echo -n $deco
}

theme_tagmark_post() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg($colBlack)^fg($colBlue500)$right_hard_arrow"
        ;;
        *) ;; # do nothing
    esac
    
    echo -n $deco
}

theme_leftside_bottom() {
    local left=""
    left+=" ^fg($colBlue100)^bg($colBlue200)$right_hard_arrow"
    left+=" $segmentHost "
    left+=" ^fg($colBlue200)^bg($colBlue300)$right_hard_arrow"
    left+=" $segmentVolume "
    left+=" ^fg($colBlue300)^bg($colBlue400)$right_hard_arrow"
    left+=" $segmentMemory "
    left+=" ^fg($colBlue400)^bg($colBlue500)$right_hard_arrow"
    left+=" $segmentDisk "
    left+=" ^fg($colBlue500)^bg($colBlue600)$right_hard_arrow"
    left+=" $segmentCPU "
    left+=" ^fg($colBlue600)^bg($colBlue700)$right_hard_arrow"
    left+=" $segmentSSID "
    left+=" ^fg($colBlue700)^bg($colBlue800)$right_hard_arrow"
    left+=" $segmentNet "
    left+=" ^fg($colBlue800)^bg($colBlue900)$right_hard_arrow"
  # left+=" $segmentUpdates "
    left+=" ^fg($colBlue900)^bg($colBlack)$right_hard_arrow"

    echo -n $left
}

theme_rightside_top() {
    # do not local $right
    right=""
    right+="^fg($colBlue600)^bg($colBlack) $left_hard_arrow"    
    right+="^bg($colBlue600) "
    right+="^fg($colBlack)^bg($colBlue600) $left_hard_arrow"
    right+="^bg($colBlack)$segmentDate "
    right+="^fg($colBlue400)^bg($colBlack) $left_hard_arrow"
    right+="^bg($colBlue400)     ."
    
    rightside_space -10
    echo -n $right
    echo
}

theme_rightside_bottom() {
    # do not local $right
    right=""
    right+="^fg($colBlue900)^bg($colBlack)$left_hard_arrow"
    right+="^bg($colBlue900)$segmentUptime "
    right+="^fg($colBlue800)^bg($colBlue900)$left_hard_arrow"
    right+="^bg($colBlue800) "
    right+="^fg($colBlue700)^bg($colBlue800)$left_hard_arrow"
    right+="^bg($colBlue700) "
    right+="^fg($colBlue600)^bg($colBlue700)$left_hard_arrow"
    right+="^bg($colBlue600) "
    right+="^fg($colBlue500)^bg($colBlue600)$left_hard_arrow"
    right+="^bg($colBlue500) "
    right+="^fg($colBlue400)^bg($colBlue500)$left_hard_arrow"
    right+="^bg($colBlue400) "
    right+="^fg($colBlue300)^bg($colBlue400)$left_hard_arrow"    
    right+="^bg($colBlue300) "
    right+="^fg($colBlack)^bg($colBlue300)$left_hard_arrow"
    right+="^bg($colBlack)$segmentMPD "
    right+="^fg($colBlue100)^bg($colBlack)$left_hard_arrow"
    right+="^bg($colBlue100)     ."
    
    rightside_space 0
    echo -n $right
    echo
}
