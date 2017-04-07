#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel parameters

bgcolor=$colWhite
fgcolor=$colBlack
alignment="c"

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

. ~/Documents/standalone/dzen2/bash/themes/shared-colorful.sh
