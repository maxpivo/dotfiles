#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

function handle_command_event() {
    local monitor=$1
    shift
    local event=$@    
    
    # find out event origin
    IFS=$'\t' column=($event);
    origin=${column[0]}
    
    # find out event origin
    case $origin in
        reload)
            pkill lemonbar
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
        interval)
            set_datetime
            ;;
    esac 
}

function content_init() {
    monitor=$1

    # initialize statusbar before loop
    set_tag_value $monitor
    set_windowtitle ''
    set_datetime

    get_statusbar_text $monitor
    echo $buffer
}

function content_event_idle() {
    # wait for each event     
    herbstclient --idle
}

function content_event_interval() {
    # endless loop
    while :; do 
      echo "interval"
      sleep 1
    done
}

function content_walk() {
    monitor=$1
    
    {
        content_event_idle &
        pid_idle=$!
    
        content_event_interval &
        pid_interval=$!
    
    }  | while read event; do
            handle_command_event $monitor "$event"
        
            get_statusbar_text $monitor
            echo $buffer
        done
}

function run_lemon() { 
    monitor=$1
    shift
    parameters=$@
    
    command_out="lemonbar $parameters"
    
    {
       content_init $monitor
       content_walk $monitor # loop for each event
    } | $command_out | sh
}

function detach_lemon() { 
    monitor=$1
    shift
    parameters=$@
    
    run_lemon $monitor $parameters &
}
