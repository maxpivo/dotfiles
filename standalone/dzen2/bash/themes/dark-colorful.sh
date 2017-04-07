#!/usr/bin/env bash


# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel parameters

bgcolor=$colBlack
fgcolor=$colWhite
alignment="c"

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

. ~/Documents/standalone/dzen2/bash/themes/shared-colorful.sh
