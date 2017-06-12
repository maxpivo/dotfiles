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
# process handler

function test_dzen2() { 
    monitor=$1
    shift
    parameters=$@
    
    command_out="dzen2 $parameters -p"
    
    {
        # initialize statusbar
        set_tag_value $monitor
        set_windowtitle 'test'

        get_statusbar_text $monitor
        echo $buffer
    } | $command_out

}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height=24
get_monitor ${@}

# do `man herbsluftclient`, and type \pad to search what it means
herbstclient pad $monitor $panel_height 0 $panel_height 0

get_dzen2_parameters $monitor $panel_height

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

# run process 
test_dzen2  $monitor $dzen2_parameters
