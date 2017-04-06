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
    left+=" ^bg($colRed800)^fg($colRed900)$right_hard_arrow"
    left+=" $segmentHost $right_soft_arrow"
    left+=" ^bg($colRed700)^fg($colRed800)$right_hard_arrow"
    left+=" $segmentVolume $right_soft_arrow"
    left+=" ^bg($colRed600)^fg($colRed700)$right_hard_arrow"
    left+=" $segmentMemory $right_soft_arrow"
    left+=" ^bg($colRed500)^fg($colRed600)$right_hard_arrow"
    left+=" $segmentDisk $right_soft_arrow"
    left+=" ^bg($colRed400)^fg($colRed500)$right_hard_arrow"
    left+=" $segmentCPU $right_soft_arrow"
    left+=" ^bg($colRed300)^fg($colRed400)$right_hard_arrow"
    left+=" $segmentSSID $right_soft_arrow"
    left+=" ^bg($colRed200)^fg($colRed300)$right_hard_arrow"
    left+=" $segmentNet $right_soft_arrow"
    left+=" ^bg($colRed100)^fg($colRed200)$right_hard_arrow"
  # left+=" $segmentUpdates $right_soft_arrow"
    left+=" ^bg($colWhite)^fg($colRed100)$right_hard_arrow"

    echo -n $left
}

theme_rightside_top() {
    # do not local $right
    right=""
    right+="^bg($colWhite)^fg($colRed100)$left_hard_arrow"
    right+="^bg($colRed100) $left_soft_arrow"
    right+="^bg($colRed100)^fg($colRed200)$left_hard_arrow"
    right+="^bg($colRed200) $left_soft_arrow"
    right+="^bg($colRed200)^fg($colRed300)$left_hard_arrow"
    right+="^bg($colRed300) $left_soft_arrow"
    right+="^bg($colRed300)^fg($colRed400)$left_hard_arrow"
    right+="^bg($colRed400) $left_soft_arrow"
    right+="^bg($colRed400)^fg($colRed500)$left_hard_arrow"
    right+="^bg($colRed500) $left_soft_arrow"
    right+="^bg($colRed500)^fg($colRed600)$left_hard_arrow"
    right+="^bg($colRed600) $left_soft_arrow"
    right+="^bg($colRed600)^fg($colRed700)$left_hard_arrow"    
    right+="^bg($colRed700) $left_soft_arrow"
    right+="^bg($colRed700)^fg($colRed800)$left_hard_arrow"
    right+="^bg($colRed800)$segmentDate $left_soft_arrow"
    right+="^bg($colRed800)^fg($colRed900)$left_hard_arrow"
    right+="^bg($colRed900)     ."
    
    rightside_space 0
    echo -n $right
    echo
}

theme_rightside_bottom() {
    # do not local $right
    right=""
    right+="^bg($colWhite)^fg($colRed100)$left_hard_arrow"
    right+="^bg($colRed100) "
    right+="^bg($colRed100)^fg($colRed200)$left_hard_arrow"
    right+="^bg($colRed200) "
    right+="^bg($colRed200)^fg($colRed300)$left_hard_arrow"
    right+="^bg($colRed300) "
    right+="^bg($colRed300)^fg($colRed400)$left_hard_arrow"
    right+="^bg($colRed400) "
    right+="^bg($colRed400)^fg($colRed500)$left_hard_arrow"
    right+="^bg($colRed500) "
    right+="^bg($colRed500)^fg($colRed600)$left_hard_arrow"
    right+="^bg($colRed600) "
    right+="^bg($colRed600)^fg($colRed700)$left_hard_arrow"    
    right+="^bg($colRed700)$segmentUptime "
    right+="^bg($colRed700)^fg($colRed800)$left_hard_arrow"
    right+="^bg($colRed800)$segmentMPD "
    right+="^bg($colRed800)^fg($colRed900)$left_hard_arrow"
    right+="^bg($colRed900)     ."
    
    rightside_space 0
    echo -n $right
    echo
}
