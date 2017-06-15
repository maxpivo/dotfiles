#!/usr/bin/env bash
# This is a modularized config for herbstluftwm tags in lemonbar

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# libraries

DIR=$(dirname "$0")
. ${DIR}/helper.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height=24
get_monitor ${@}

get_lemon_parameters $monitor $panel_height
echo $lemon_parameters 
