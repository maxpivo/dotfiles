#!/usr/bin/env bash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

# geometry calculation

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi

# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=16

bgcolor=$(hc get frame_border_normal_color)

. ~/.config/herbstluftwm/bash/dzen2/helper.sh
. ~/.config/herbstluftwm/bash/dzen2/output.sh
. ~/.config/herbstluftwm/bash/dzen2/event.sh

hc pad $monitor $panel_height

event_generator() {
    ### Event generator ###
    # based on different input data (mpc, date, hlwm hooks, ...) this generates events, formed like this:
    #   <eventname>\t<data> [...]
    # e.g.
    #   date    ^fg(#efefef)18:33^fg(#909090), 2013-10-^fg(#efefef)29
    
  # player (mpd)
    mpc idleloop player &
    mpc_pid=$!

  # tick
    while true; do echo tick; sleep 20; done &
    tick_pid=$!

  # date
    while true ; do
        # "date" output is checked once a second, but an event is only
        # generated if the output changed compared to the previous run.
        date +$'date\t^fg(#efefef)%H:%M^fg(#909090), %Y-%m-^fg(#efefef)%d'
        sleep 1 || break
    done > >(uniq_linebuffered) &
    date_pid=$!

  # hlwm events
    hc --idle
    
  # exiting; kill stray event-emitting processes
    kill $date_pid $mpc_pid $tick_pid

} 

generated_output() {
    # http://wiki.bash-hackers.org/commands/builtin/read
    # http://wiki.bash-hackers.org/syntax/shellvars#ifs
    IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
    visible=true 
    
    while true ; do
        ### Output ###
        # This part prints dzen data based on the _previous_ data handling run,
        # and then waits for the next event to happen.

        # draw tags
        for i in "${tags[@]}" ; do
            output_by_tagmark $i
            output_by_tagnumber $i            
        done
        
        output_leftside
        output_rightside

        handle_cmd_event
    done

    ### dzen2 ###
    # After the data is gathered and processed, the output of the previous block
    # gets piped to dzen2.

}

font_default="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
font="-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*"
#font="takaopgothic-9"

dzen2_parameters="  -x $x -y $y -w $panel_width -h 16 " 
dzen2_parameters+=" -fn $font"
dzen2_parameters+=" -ta l -bg $bgcolor -fg #efefef"


# By redirecting stderr to /dev/null, you effectively suppress these messages.
# 2> /dev/null

event_generator 2> /dev/null | generated_output 2> /dev/null | dzen2 $dzen2_parameters \
    -e 'button3=;button4=exec:herbstclient use_index -1;button5=exec:herbstclient use_index +1'
