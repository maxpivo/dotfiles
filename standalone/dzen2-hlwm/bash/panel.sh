#!/usr/bin/env bash
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# libraries

DIR=$(dirname "$0")

. ${DIR}/gmc.sh
. ${DIR}/helper.sh
. ${DIR}/output.sh
. ${DIR}/pipehandler.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

panel_height=24
get_monitor ${@}

pkill dzen2
herbstclient pad $monitor $panel_height 0 $panel_height 0

# run process in the background

get_params_top $monitor $panel_height
detach_dzen2 $monitor $dzen2_parameters

get_params_bottom $monitor $panel_height
detach_dzen2_conky $dzen2_parameters

# optional transparency
detach_transset
