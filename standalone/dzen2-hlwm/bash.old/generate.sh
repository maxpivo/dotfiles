#!/usr/bin/env bash

content() {   
    while true ; do
        statusbar_text

        handle_cmd_event
    done

    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

}

statusbar_text() {
    ### Output ###
    # This part prints dzen data based on the _previous_ data handling run,
    # and then waits for the next event to happen.
    
    text=''

    # draw tags
    for i in "${tags[@]}" ; do
        text+=$(output_by_tagmark_pre $i)
        text+=$(output_by_tagnumber $i)
        text+=$(output_by_tagmark_post $i)
    done
        
    text+=$(output_leftside_top)
    echo $text
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
            pkill dzen2
            exit
            ;;
        quit_panel)
            exit
            ;;
        tag*)
            # http://www.tldp.org/LDP/abs/html/x17837.html#HERESTRINGSREF
            # echo "resetting tags" >&2
            set_tag_value
            ;;
        focus_changed|window_title_changed)
            set_windowtitle "${cmd[@]:2}"
            ;;
    esac
}



# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# Initial Value

init_segments() {
    set_windowtitle ""
    set_tag_value
}
