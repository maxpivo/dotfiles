#!/usr/bin/env bash

# this script use variables form panel.sh

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
        tag*)
            # http://www.tldp.org/LDP/abs/html/x17837.html#HERESTRINGSREF
            # echo "resetting tags" >&2
            IFS=$'\t' read -ra tags <<< "$(hc tag_status $monitor)"
            ;;
        date)
            # echo "resetting date" >&2
            date="${cmd[@]:1}"
            ;;
        quit_panel)
            exit
            ;;
        togglehidepanel)
            currentmonidx=$(hc list_monitors | sed -n '/\[FOCUS\]$/s/:.*//p')
            if [ "${cmd[1]}" -ne "$monitor" ] ; then
                continue
            fi
            if [ "${cmd[1]}" = "current" ] && [ "$currentmonidx" -ne "$monitor" ] ; then
                continue
            fi
            echo "^togglehide()"
            if $visible ; then
                visible=false
                hc pad $monitor 0
            else
                visible=true
                hc pad $monitor $panel_height
            fi
            ;;
        reload)
            exit
            ;;
        focus_changed|window_title_changed)
            windowtitle="${cmd[@]:2}"
            ;;
        mpd_player|player)
            nowplaying="$(mpc current -f '^fg(##c9c925)[%artist% ^fg()- ]^fg(##5c5dad)[%title%|%file%]')"
            ;;
        #player)
        #    ;;
    esac
}
