#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel color

bgcolor=${color['white']}
fgcolor=${color['black']}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

#plain
separator="^bg()^fg(${color['black']})|^bg()^fg()"

preIcon="^fg(${color['yellow500']})$FontAwesome"
postIcon="^fn()^fg()"
labelColor="^fg(${color['grey300']})"
valueColor="^fg(${color['grey900']})"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

theme_tagmark_pre() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg(${color['blue500']})^fg(${color['white']})$right_hard_arrow"
             deco+="^bg(${color['blue500']})^fg(${color['black']})"     
        ;;
        '+') deco+="^bg(${color['yellow500']})^fg(${color['grey400']})" ;;
        ':') deco+="^bg()^fg(${color['black']})"                ;;
        '!') deco+="^bg(${color['red500']})^fg(${color['black']})"      ;;
        *)   deco+="^bg()^fg(${color['grey600']})"              ;;
    esac
    
    echo -n $deco
}

theme_tagmark_post() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg(${color['white']})^fg(${color['blue500']})$right_hard_arrow"
        ;;
        *) ;; # do nothing
    esac
    
    echo -n $deco
}

theme_leftside_bottom() {
    local left=""
    left+=" ^bg(${color['red800']})^fg(${color['red900']})$right_hard_arrow"
    left+=" $segmentHost $right_soft_arrow"
    left+=" ^bg(${color['red700']})^fg(${color['red800']})$right_hard_arrow"
#    left+=" $segmentVolume $right_soft_arrow"
    left+=" $right_soft_arrow"
    left+=" ^bg(${color['red600']})^fg(${color['red700']})$right_hard_arrow"
#    left+=" $segmentMemory $right_soft_arrow"
    left+=" $right_soft_arrow"
    left+=" ^bg(${color['red500']})^fg(${color['red600']})$right_hard_arrow"
#    left+=" $segmentDisk $right_soft_arrow"
    left+=" $right_soft_arrow"
    left+=" ^bg(${color['red400']})^fg(${color['red500']})$right_hard_arrow"
    left+=" $segmentCPU $right_soft_arrow"
    left+=" ^bg(${color['red300']})^fg(${color['red400']})$right_hard_arrow"
    left+=" $segmentSSID $right_soft_arrow"
    left+=" ^bg(${color['red200']})^fg(${color['red300']})$right_hard_arrow"
    left+=" $segmentNet $right_soft_arrow"
    left+=" ^bg(${color['red100']})^fg(${color['red200']})$right_hard_arrow"
  # left+=" $segmentUpdates $right_soft_arrow"
    left+=" ^bg(${color['White']})^fg(${color['red100']})$right_hard_arrow"

    echo -n $left
}

theme_rightside_top() {
    # do not local $right
    right=""
    right+="^bg(${color['White']})^fg(${color['red100']})$left_hard_arrow"
    right+="^bg(${color['red100']}) $left_soft_arrow"
    right+="^bg(${color['red100']})^fg(${color['red200']})$left_hard_arrow"
    right+="^bg(${color['red200']}) $left_soft_arrow"
    right+="^bg(${color['red200']})^fg(${color['red300']})$left_hard_arrow"
    right+="^bg(${color['red300']}) $left_soft_arrow"
    right+="^bg(${color['red300']})^fg(${color['red400']})$left_hard_arrow"
    right+="^bg(${color['red400']}) $left_soft_arrow"
    right+="^bg(${color['red400']})^fg(${color['red500']})$left_hard_arrow"
    right+="^bg(${color['red500']}) $left_soft_arrow"
    right+="^bg(${color['red500']})^fg(${color['red600']})$left_hard_arrow"
    right+="^bg(${color['red600']}) $left_soft_arrow"
    right+="^bg(${color['red600']})^fg(${color['red700']})$left_hard_arrow"    
    right+="^bg(${color['red700']}) $left_soft_arrow"
    right+="^bg(${color['red700']})^fg(${color['red800']})$left_hard_arrow"
    right+="^bg(${color['red800']})$segmentDate $left_soft_arrow"
    right+="^bg(${color['red800']})^fg(${color['red900']})$left_hard_arrow"
    right+="^bg(${color['red900']})     ."
    
    rightside_space 0
    echo -n $right
    echo
}

theme_rightside_bottom() {
    # do not local $right
    right=""
    right+="^bg(${color['White']})^fg(${color['red100']})$left_hard_arrow"
    right+="^bg(${color['red100']}) "
    right+="^bg(${color['red100']})^fg(${color['red200']})$left_hard_arrow"
    right+="^bg(${color['red200']}) "
    right+="^bg(${color['red200']})^fg(${color['red300']})$left_hard_arrow"
    right+="^bg(${color['red300']}) "
    right+="^bg(${color['red300']})^fg(${color['red400']})$left_hard_arrow"
    right+="^bg(${color['red400']}) "
    right+="^bg(${color['red400']})^fg(${color['red500']})$left_hard_arrow"
    right+="^bg(${color['red500']}) "
    right+="^bg(${color['red500']})^fg(${color['red600']})$left_hard_arrow"
    right+="^bg(${color['red600']}) "
    right+="^bg(${color['red600']})^fg(${color['red700']})$left_hard_arrow"    
    right+="^bg(${color['red700']})$segmentUptime "
    right+="^bg(${color['red700']}) "
    right+="^bg(${color['red700']})^fg(${color['red800']})$left_hard_arrow"
    right+="^bg(${color['red800']})$segmentMPD "
    right+="^bg(${color['red800']})^fg(${color['red900']})$left_hard_arrow"
    right+="^bg(${color['red900']})     ."
    
    rightside_space 0
    echo -n $right
    echo
}
