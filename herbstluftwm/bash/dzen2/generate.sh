#!/usr/bin/env bash

event_generator_top() {
   
    ### Event generator ###
    # based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
    #   <eventname>\t<data> [...]
    # e.g.
    #   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29

    # endless loop can be written as
    # while true ; do
    # or
    # while :; do

  # date
    while :; do  
        # "date" output is checked once a second, but an event is only
        # generated if the output changed compared to the previous run.
        evDate
        sleep 1 || break
    done > >(uniq_linebuffered) &
    date_pid=$!
    
  # hlwm events
    hc --idle
    
  # exiting; kill stray event-emitting processes
    kill $date_pid 
} 

event_generator_bottom() {
      
  # player (mpd)
    mpc idleloop player &
    mpc_pid=$!

  # batch
    while true ; do
        evVolume
        evMemory
        evDisk
        evCPU
        evNet
        sleep 1 || break
    done &
    batch_pid=$!

  # hlwm events
    hc --idle
    
  # exiting; kill stray event-emitting processes
    kill $mpc_pid $batch_pid 
} 

generated_output_top() {   
    while true ; do
        ### Output ###
        # This part prints dzen data based on the _previous_ data handling run,
        # and then waits for the next event to happen.

        # draw tags
        for i in "${tags[@]}" ; do
            output_by_tagmark $i
            output_by_tagnumber $i            
        done
        
        output_leftside_top
        output_rightside_top

        handle_cmd_event
    done

    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

}

generated_output_bottom() {   
    while true ; do
        ### Output ###
        # This part prints dzen data based on the _previous_ data handling run,
        # and then waits for the next event to happen.
       
        output_leftside_bottom
        output_rightside_bottom

        handle_cmd_event
    done

    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

}

handle_cmd_event() {
    ### Data handling ###
    # This part handles the events generated in the event loop, and sets
    # internal variables based on them. The event and its arguments are
    # read into the array cmd, then action is taken depending on the event
    # name.
    # "Special" events (quit_panel/togglehidepanel/reload) are also handled
    # here.

    # wait for next event
    IFS=$'\t' read -ra cmd || break

    # find out event origin
    case "${cmd[0]}" in
        reload)
            exit
            ;;
        quit_panel)
            exit
            ;;
        tag*)
            # http://www.tldp.org/LDP/abs/html/x17837.html#HERESTRINGSREF
            # echo "resetting tags" >&2
            setTagValue
            ;;
        focus_changed|window_title_changed)
            setWindowtitle "${cmd[@]:2}"
            ;;
        date)
            # echo "resetting date" >&2            
            setDate
            ;;
        mpd_player|player)
            setMPD
            ;;
        volume)
            setVolume "${cmd[@]:1}"
            ;;
        memory)
            setMemory "${cmd[@]:1}"
            ;;
        disk)
            setDisk "${cmd[@]:1}"
            ;;
        cpu)
            setCPU "${cmd[@]:1}"
            ;;
        net)
            setNet "${cmd[@]:1}"
            ;;
    esac
}
