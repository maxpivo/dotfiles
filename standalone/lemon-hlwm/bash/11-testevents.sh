#!/usr/bin/env bash

function content_event_idle() {
    # wait for each event     
    herbstclient --idle
}

function content_event_interval() {
    # endless loop
    while :; do 
      date +$'interval\t%H:%M:%S'
      sleep 3
    done
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

{
    content_event_idle &
    pid_idle=$!
    
    content_event_interval &
    pid_interval=$!
    
}  | while read event; do
        echo "$event"
        
        # uncomment to examine more complete behaviour
        # echo -e "tab:\t[${event}]"
    done    

kill pid_idle
kill pid_interval
