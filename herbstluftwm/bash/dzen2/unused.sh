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

event_generator_bottom() {
      
  # player (mpd)
    mpc idleloop player &
    mpc_pid=$!

  # volume
    while true ; do
        evVolume
        sleep 1 || break
    done > >(uniq_linebuffered) &
    volume_pid=$!

  # memory
    while true ; do
        evMemory
        sleep 1 || break
    done > >(uniq_linebuffered) &
    memory_pid=$!
    
  # disk free
    while true ; do
        evDisk
        sleep 1 || break
    done > >(uniq_linebuffered) &
    disk_pid=$!
    
  # cpu usage
    while true ; do
        evCPU
        sleep 1 || break
    done > >(uniq_linebuffered) &
    cpu_pid=$!
    
  # net speed
    while true ; do
        evNet
        sleep 1 || break
    done > >(uniq_linebuffered) &
    net_pid=$!

  # hlwm events
    hc --idle
    
  # exiting; kill stray event-emitting processes
    kill $mpc_pid $volume_pid $memory_pid $disk_pid $cpu_id $net_id
} 

# unused
theme_leftside_bottom_left_arrow() {
    local left=""
    left+="^fg($colRed800)^bg($colRed900) $left_hard_arrow"
    left+="^bg($colRed800)$segmentHost "
    left+="^fg($colRed700)^bg($colRed800) $left_hard_arrow"
    left+="^bg($colRed700)$segmentVolume "
    left+="^fg($colRed600)^bg($colRed700) $left_hard_arrow"
    left+="^bg($colRed600)$segmentMemory "
    left+="^fg($colRed500)^bg($colRed600) $left_hard_arrow"
    left+="^bg($colRed500)$segmentDisk "
    left+="^fg($colRed400)^bg($colRed500) $left_hard_arrow"
    left+="^bg($colRed400)$segmentCPU "
    left+="^fg($colRed300)^bg($colRed400) $left_hard_arrow"
    left+="^bg($colRed300)$segmentSSID "
    left+="^fg($colRed200)^bg($colRed300) $left_hard_arrow"
    left+="^bg($colRed200)$segmentNet "
    left+="^fg($colRed100)^bg($colRed200) $left_hard_arrow"
  # left+=" $segmentUpdates "
    left+="^fg($colWhite)^bg($colRed100) $left_hard_arrow"

    echo -n $left
}
