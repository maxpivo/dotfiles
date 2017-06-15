#!/usr/bin/env bash
# This is a modularized config for herbstluftwm tags in lemonbar

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# libraries

DIR=$(dirname "$0")

. ${DIR}/gmc.sh
. ${DIR}/helper.sh
. ${DIR}/output.sh
. ${DIR}/pipehandler.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height=24
get_monitor ${@}
get_lemon_parameters $monitor $panel_height

# do `man herbsluftclient`, and type \pad to search what it means
herbstclient pad $monitor $panel_height 0 $panel_height 0

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

# remove all lemonbar instance
pkill lemonbar

# run process in the background
detach_lemon $monitor $lemon_parameters

