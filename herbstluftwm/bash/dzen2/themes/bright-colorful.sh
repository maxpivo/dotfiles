#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel color

bgcolor=$colWhite
fgcolor=$colBlack

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

#plain
separator="^bg()^fg($colBlack)|^bg()^fg()"

preIcon="^fg($colPink700)$FontAwesome"
postIcon="^fn()^fg()"
labelColor="^fg($colGrey700)"
valueColor="^fg($colBlue700)"


# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

. ~/.config/herbstluftwm/bash/dzen2/themes/shared-colorful.sh

theme_tagmark_pre() {
    local deco
    local tagmark=$1

    case $tagmark in
        '#') deco="^bg($colBlue500)^fg($colBlack)"     ;;
        '+') deco="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco="^bg()^fg($colBlack)"                ;;
        '!') deco="^bg($colRed500)^fg($colBlack)"      ;;
        *)   deco="^bg()^fg($colGrey600)"              ;;
    esac
    
    echo -n $deco
}

