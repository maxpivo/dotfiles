#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel color

bgcolor=${color['white']}
fgcolor=${color['black']}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

#plain
separator="^bg()^fg(${color['black']})|^bg()^fg()"

preIcon="^fg(${color['pink700']})$FontAwesome"
postIcon="^fn()^fg()"
labelColor="^fg(${color['grey700']})"
valueColor="^fg(${color['blue700']})"


# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

. ~/.config/herbstluftwm/bash/dzen2/themes/shared-colorful.sh

theme_tagmark_pre() {
    local deco
    local tagmark=$1

    case $tagmark in
        '#') deco="^bg(${color['blue500']})^fg(${color['black']})"     ;;
        '+') deco="^bg(${color['yellow500']})^fg(${color['grey400']})" ;;
        ':') deco="^bg()^fg(${color['black']})"                ;;
        '!') deco="^bg(${color['red500']})^fg(${color['black']})"      ;;
        *)   deco="^bg()^fg(${color['grey600']})"              ;;
    esac
    
    echo -n $deco
}

