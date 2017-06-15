#!/usr/bin/env bash
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# libraries

DIR=$(dirname "$0")
. ${DIR}/helper.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height=24
get_monitor ${@}

get_dzen2_parameters $monitor $panel_height
echo $dzen2_parameters
