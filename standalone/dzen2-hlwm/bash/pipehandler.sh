#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

function handle_command_event() {
    local monitor=$1
    shift
    local event=$@    
    
    # find out event origin
    IFS=$'\t'  column=($event);
    origin=${column[0]}
    
    # find out event origin
    case $origin in
        reload)
            pkill dzen2
            ;;
        quit_panel)
            exit
            ;;
        tag*)
            # http://www.tldp.org/LDP/abs/html/x17837.html#HERESTRINGSREF
            # echo "resetting tags" >&2
            set_tag_value $monitor
            ;;
        focus_changed|window_title_changed)
            set_windowtitle "${column[2]}"
            ;;
    esac 
}

function content_init() {
    monitor=$1

    # initialize statusbar before loop
    set_tag_value $monitor
    set_windowtitle ''

    get_statusbar_text $monitor
    echo $buffer
}

function content_walk() {
    monitor=$1

    # start a pipe
    command_in='herbstclient --idle'

    # wait for each event     
    $command_in | while read event; do
        handle_command_event $monitor "$event"
        
        get_statusbar_text $monitor
        echo $buffer
    done    
}

function run_dzen2() { 
    monitor=$1
    shift
    parameters=$@
    
    command_out="dzen2 $parameters"
    
    {
       content_init $monitor
       content_walk $monitor # loop for each event
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
