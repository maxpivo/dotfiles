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

pkill lemonbar
herbstclient pad $monitor $panel_height 0 $panel_height 0

# run process in the background

get_params_top $monitor $panel_height
detach_lemon $monitor $lemon_parameters

get_params_bottom $monitor $panel_height
detach_lemon_conky $lemon_parameters
