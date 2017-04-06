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
    left+=" ^bg($colBlue200)^fg($colBlue100)$right_hard_arrow"
    left+=" $segmentHost "
    left+=" ^bg($colBlue300)^fg($colBlue200)$right_hard_arrow"
    left+=" $segmentVolume "
    left+=" ^bg($colBlue400)^fg($colBlue300)$right_hard_arrow"
    left+=" $segmentMemory "
    left+=" ^bg($colBlue500)^fg($colBlue400)$right_hard_arrow"
    left+=" $segmentDisk "
    left+=" ^bg($colBlue600)^fg($colBlue500)$right_hard_arrow"
    left+=" $segmentCPU "
    left+=" ^bg($colBlue700)^fg($colBlue600)$right_hard_arrow"
    left+=" $segmentSSID "
    left+=" ^bg($colBlue800)^fg($colBlue700)$right_hard_arrow"
    left+=" $segmentNet "
    left+=" ^bg($colBlue900)^fg($colBlue800)$right_hard_arrow"
  # left+=" $segmentUpdates "
    left+=" ^bg($colBlack)^fg($colBlue900)$right_hard_arrow"

    echo -n $left
}

theme_rightside_top() {
    # do not local $right
    right=""
    right+="^bg($colBlack)^fg($colBlue600) $left_hard_arrow"    
    right+="^bg($colBlue600) "
    right+="^bg($colBlue600)^fg($colBlack) $left_hard_arrow"
    right+="^bg($colBlack)$segmentDate "
    right+="^bg($colBlack)^fg($colBlue400) $left_hard_arrow"
    right+="^bg($colBlue400)     ."
    
    rightside_space -10
    echo -n $right
    echo
}

theme_rightside_bottom() {
    # do not local $right
    right=""
    right+="^bg($colBlack)^fg($colBlue900)$left_hard_arrow"
    right+="^bg($colBlue900)$segmentUptime "
    right+="^bg($colBlue900)^fg($colBlue800)$left_hard_arrow"
    right+="^bg($colBlue800) "
    right+="^bg($colBlue800)^fg($colBlue700)$left_hard_arrow"
    right+="^bg($colBlue700) "
    right+="^bg($colBlue700)^fg($colBlue600)$left_hard_arrow"
    right+="^bg($colBlue600) "
    right+="^bg($colBlue600)^fg($colBlue500)$left_hard_arrow"
    right+="^bg($colBlue500) "
    right+="^bg($colBlue500)^fg($colBlue400)$left_hard_arrow"
    right+="^bg($colBlue400) "
    right+="^bg($colBlue400)^fg($colBlue300)$left_hard_arrow"    
    right+="^bg($colBlue300) "
    right+="^bg($colBlue300)^fg($colBlack)$left_hard_arrow"
    right+="^bg($colBlack)$segmentMPD "
    right+="^bg($colBlack)^fg($colBlue100)$left_hard_arrow"
    right+="^bg($colBlue100)     ."
    
    rightside_space 0
    echo -n $right
    echo
}
