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
labelColor="^fg($colGrey700)"
valueColor="^fg($colBlue300)"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

. ~/.config/herbstluftwm/bash/dzen2/themes/shared-colorful.sh

theme_tagmark_pre_dark() {
    local deco
    local tagmark=$1

    case $tagmark in
        '#') deco="^bg($colBlue500)^fg($colWhite)"     ;;
        '+') deco="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco="^bg()^fg($colWhite)"                ;;
        '!') deco="^bg($colRed500)^fg($colWhite)"      ;;
        *)   deco="^bg()^fg($colGrey600)"              ;;
    esac
    
    echo -n $deco
}
