#!/usr/bin/env bash
# This is a modularized config for herbstluftwm tags in lemonbar

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# libraries

DIR=$(dirname "$0")
. ${DIR}/gmc.sh
. ${DIR}/helper.sh
. ${DIR}/output.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# process handler

function test_lemon() { 
    local monitor=$1
    shift
    local parameters=$@
    
    local command_out="lemonbar $parameters -p"
    
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
get_lemon_parameters $monitor $panel_height

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

# do `man herbsluftclient`, and type \pad to search what it means
herbstclient pad $monitor $panel_height 0 $panel_height 0

# run process
test_lemon $monitor $lemon_parameters

