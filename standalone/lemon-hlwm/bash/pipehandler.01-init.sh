#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

function content_init() {
    monitor=$1

    # initialize statusbar before loop
    set_tag_value $monitor
    set_windowtitle ''

    get_statusbar_text $monitor
    echo $buffer
}

function run_lemon() { 
    monitor=$1
    shift
    parameters=$@
    
    command_out="lemonbar $parameters -p"
    
    {
       content_init $monitor
    } | $command_out
}

function detach_lemon() { 
    monitor=$1
    shift
    parameters=$@
    
    run_lemon $monitor $parameters &
}
