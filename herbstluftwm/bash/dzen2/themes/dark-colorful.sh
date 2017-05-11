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
labelColor="^fg(${color['grey700']})"
valueColor="^fg(${color['blue300']})"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

. ~/.config/herbstluftwm/bash/dzen2/themes/shared-colorful.sh

theme_tagmark_pre_dark() {
    local deco
    local tagmark=$1

    case $tagmark in
        '#') deco="^bg(${color['blue500']})^fg(${color['white']})"     ;;
        '+') deco="^bg(${color['yellow500']})^fg(${color['grey400']})" ;;
        ':') deco="^bg()^fg(${color['white']})"                ;;
        '!') deco="^bg(${color['red500']})^fg(${color['white']})"      ;;
        *)   deco="^bg()^fg(${color['grey600']})"              ;;
    esac
    
    echo -n $deco
}
