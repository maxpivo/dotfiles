#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel color

bgcolor=${color['black']}
fgcolor=${color['white']}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

#plain
separator="^bg()^fg(${color['white']})|^bg()^fg()"

preIcon="^fg(${color['yellow500']})$FontAwesome"
postIcon="^fn()^fg()"
labelColor="^fg(${color['grey900']})"
valueColor="^fg(${color['grey100']})"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

theme_tagmark_pre() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg(${color['blue500']})^fg(${color['black']})$right_hard_arrow"
             deco+="^bg(${color['blue500']})^fg(${color['white']})"     
        ;;
        '+') deco="^bg(${color['yellow500']})^fg(${color['grey400']})" ;;
        ':') deco="^bg()^fg(${color['white']})"                ;;
        '!') deco="^bg(${color['red500']})^fg(${color['white']})"      ;;
        *)   deco="^bg()^fg(${color['grey600']})"              ;;
    esac
    
    echo -n $deco
}

theme_tagmark_post() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg(${color['black']})^fg(${color['blue500']})$right_hard_arrow"
        ;;
        *) ;; # do nothing
    esac
    
    echo -n $deco
}

theme_leftside_bottom() {
    local left=""
    left+=" ^bg(${color['blue200']})^fg(${color['blue100']})$right_hard_arrow"
    left+=" $segmentHost "
    left+=" ^bg(${color['blue300']})^fg(${color['blue200']})$right_hard_arrow"
    left+=" $segmentVolume "
    left+=" ^bg(${color['blue400']})^fg(${color['blue300']})$right_hard_arrow"
    left+=" $segmentMemory "
    left+=" ^bg(${color['blue500']})^fg(${color['blue400']})$right_hard_arrow"
    left+=" $segmentDisk "
    left+=" ^bg(${color['blue600']})^fg(${color['blue500']})$right_hard_arrow"
    left+=" $segmentCPU "
    left+=" ^bg(${color['blue700']})^fg(${color['blue600']})$right_hard_arrow"
    left+=" $segmentSSID "
    left+=" ^bg(${color['blue800']})^fg(${color['blue700']})$right_hard_arrow"
    left+=" $segmentNet "
    left+=" ^bg(${color['blue900']})^fg(${color['blue800']})$right_hard_arrow"
  # left+=" $segmentUpdates "
    left+=" ^bg(${color['black']})^fg(${color['blue900']})$right_hard_arrow"

    echo -n $left
}

theme_rightside_top() {
    # do not local $right
    right=""
    right+="^bg(${color['black']})^fg(${color['blue600']}) $left_hard_arrow"    
    right+="^bg(${color['blue600']}) "
    right+="^bg(${color['blue600']})^fg(${color['black']}) $left_hard_arrow"
    right+="^bg(${color['black']})$segmentDate "
    right+="^bg(${color['black']})^fg(${color['blue400']}) $left_hard_arrow"
    right+="^bg(${color['blue400']})     ."
    
    rightside_space -10
    echo -n $right
    echo
}

theme_rightside_bottom() {
    # do not local $right
    right=""
    right+="^bg(${color['black']})^fg(${color['blue900']})$left_hard_arrow"
    right+="^bg(${color['blue900']})$segmentUptime "
    right+="^bg(${color['blue900']})^fg(${color['blue800']})$left_hard_arrow"
    right+="^bg(${color['blue800']}) "
    right+="^bg(${color['blue800']})^fg(${color['blue700']})$left_hard_arrow"
    right+="^bg(${color['blue700']}) "
    right+="^bg(${color['blue700']})^fg(${color['blue600']})$left_hard_arrow"
    right+="^bg(${color['blue600']}) "
    right+="^bg(${color['blue600']})^fg(${color['blue500']})$left_hard_arrow"
    right+="^bg(${color['blue500']}) "
    right+="^bg(${color['blue500']})^fg(${color['blue400']})$left_hard_arrow"
    right+="^bg(${color['blue400']}) "
    right+="^bg(${color['blue400']})^fg(${color['blue300']})$left_hard_arrow"    
    right+="^bg(${color['blue300']}) "
    right+="^bg(${color['blue300']})^fg(${color['black']})$left_hard_arrow"
    right+="^bg(${color['black']})$segmentMPD "
    right+="^bg(${color['black']})^fg(${color['blue100']})$left_hard_arrow"
    right+="^bg(${color['blue100']})     ."
    
    rightside_space 0
    echo -n $right
    echo
}
