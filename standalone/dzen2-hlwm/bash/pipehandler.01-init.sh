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

function run_dzen2() { 
    monitor=$1
    shift
    parameters=$@
    
    command_out="dzen2 $parameters -p"
    
    {
       content_init $monitor
    } | $command_out
}

function detach_dzen2() { 
    monitor=$1
    shift
    parameters=$@
    
    run_dzen2 $monitor $parameters &
}

function detach_transset() { 
    {
        sleep 1  
        exec `(transset .8 -n dzentop >/dev/null)`
    } &
}
