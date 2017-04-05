#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel color

bgcolor=$colWhite
fgcolor=$colBlack

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

theme_tagmark_pre() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg($colBlue500)^fg($colWhite)$right_hard_arrow"
             deco+="^bg($colBlue500)^fg($colBlack)"     
        ;;
        '+') deco+="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco+="^bg()^fg($colBlack)"                ;;
        '!') deco+="^bg($colRed500)^fg($colBlack)"      ;;
        *)   deco+="^bg()^fg($colGrey600)"              ;;
    esac
    
    echo -n $deco
}

theme_tagmark_post() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg($colWhite)^fg($colBlue500)$right_hard_arrow"
        ;;
        *) ;; # do nothing
    esac
    
    echo -n $deco
}

theme_leftside_bottom() {
    local left=""
    left+=" ^fg($colRed900)^bg($colRed800)$right_hard_arrow"
    left+=" $segmentHost "
    left+=" ^fg($colRed800)^bg($colRed700)$right_hard_arrow"
    left+=" $segmentVolume "
    left+=" ^fg($colRed700)^bg($colRed600)$right_hard_arrow"
    left+=" $segmentMemory "
    left+=" ^fg($colRed600)^bg($colRed500)$right_hard_arrow"
    left+=" $segmentDisk "
    left+=" ^fg($colRed500)^bg($colRed400)$right_hard_arrow"
    left+=" $segmentCPU "
    left+=" ^fg($colRed400)^bg($colRed300)$right_hard_arrow"
    left+=" $segmentSSID "
    left+=" ^fg($colRed300)^bg($colRed200)$right_hard_arrow"
    left+=" $segmentNet "
    left+=" ^fg($colRed200)^bg($colRed100)$right_hard_arrow"
  # left+=" $segmentUpdates "
    left+=" ^fg($colRed100)^bg($colWhite)$right_hard_arrow"

    echo -n $left
}

theme_rightside_top() {
    # do not local $right
    right=""
    right+="^fg($colRed100)^bg($colWhite)$left_hard_arrow"
    right+="^bg($colRed100) "
    right+="^fg($colRed200)^bg($colRed100)$left_hard_arrow"
    right+="^bg($colRed200) "
    right+="^fg($colRed300)^bg($colRed200)$left_hard_arrow"
    right+="^bg($colRed300) "
    right+="^fg($colRed400)^bg($colRed300)$left_hard_arrow"
    right+="^bg($colRed400) "
    right+="^fg($colRed500)^bg($colRed400)$left_hard_arrow"
    right+="^bg($colRed500) "
    right+="^fg($colRed600)^bg($colRed500)$left_hard_arrow"
    right+="^bg($colRed600) "
    right+="^fg($colRed700)^bg($colRed600)$left_hard_arrow"    
    right+="^bg($colRed700) "
    right+="^fg($colRed800)^bg($colRed700)$left_hard_arrow"
    right+="^bg($colRed800)$segmentDate "
    right+="^fg($colRed900)^bg($colRed800)$left_hard_arrow"
    right+="^bg($colRed900)     ."
    
    rightside_space 0
    echo -n $right
    echo
}

theme_rightside_bottom() {
    # do not local $right
    right=""
    right+="^fg($colRed100)^bg($colWhite)$left_hard_arrow"
    right+="^bg($colRed100) "
    right+="^fg($colRed200)^bg($colRed100)$left_hard_arrow"
    right+="^bg($colRed200) "
    right+="^fg($colRed300)^bg($colRed200)$left_hard_arrow"
    right+="^bg($colRed300) "
    right+="^fg($colRed400)^bg($colRed300)$left_hard_arrow"
    right+="^bg($colRed400) "
    right+="^fg($colRed500)^bg($colRed400)$left_hard_arrow"
    right+="^bg($colRed500) "
    right+="^fg($colRed600)^bg($colRed500)$left_hard_arrow"
    right+="^bg($colRed600) "
    right+="^fg($colRed700)^bg($colRed600)$left_hard_arrow"    
    right+="^bg($colRed700)$segmentUptime "
    right+="^fg($colRed800)^bg($colRed700)$left_hard_arrow"
    right+="^bg($colRed800)$segmentMPD "
    right+="^fg($colRed900)^bg($colRed800)$left_hard_arrow"
    right+="^bg($colRed900)     ."
    
    rightside_space 0
    echo -n $right
    echo
}
