#!/usr/bin/env bash

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

# do `man herbsluftclient`, and type \pad to search what it means
herbstclient pad $monitor $panel_height 0 $panel_height 0

get_dzen2_parameters $monitor $panel_height

# init_segments

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

# remove all dzen2 instance
pkill dzen2

# run process in the background
detach_dzen2 $monitor $dzen2_parameters

# By redirecting stderr to /dev/null,
# you effectively suppress these messages.
# 2> /dev/null
#hc --idle 2> /dev/null | content 2> /dev/null | dzen2 $dzen2_parameters &

# optional transparency
detach_transset
