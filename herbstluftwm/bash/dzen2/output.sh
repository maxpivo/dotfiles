#!/usr/bin/env bash

tag_shows=( "一 ichi" "二 ni" "三 san" "四 shi" 
  "五 go" "六 roku" "七 shichi" "八 hachi" "九 kyū" "十 jū")

date=""
windowtitle=""
bordercolor="#26221C"
separator="^bg()^fg(#5c5dad)|"

nowplaying="$(mpc current -f '^fg(##c9c925)[%artist% ^fg()- ]^fg(##5c5dad)[%title%|%file%]')"

output_by_tagmark() {
    $i=$1
    tagmark=${i:0:1}

    case $tagmark in
        '#')
            echo -n "^bg(#5c5dad)^fg(#ffffff)"
            ;;
        '+')
            echo -n "^bg(#9CA668)^fg(#141414)"
            ;;
        ':')
            echo -n "^bg()^fg(#ffffff)"
            ;;
        '!')
            echo -n "^bg(#FF0675)^fg(#141414)"
            ;;
        *)
            echo -n "^bg()^fg(#ababab)"
            ;;
    esac
}

output_by_tagnumber() {
    $i=$1
    
    index=${i:1}-1
    key=${tag_shows[$index]}
    if [ ! -z "$dzen2_svn" ] ; then
        # clickable tags if using SVN dzen
        echo -n "^ca(1,\"${herbstclient_command[@]:-herbstclient}\" "
        echo -n "focus_monitor \"$monitor\" && "
        echo -n "\"${herbstclient_command[@]:-herbstclient}\" "
        echo -n "use \"${i:1}\") ${key} ^ca()"
    else
        # non-clickable tags if using older dzen
        echo -n " ${i:1} "
    fi
}

output_leftside() {
    echo -n "$separator"
    echo -n "^bg()^fg(#c9c925) ${windowtitle//^/^^}"
}

output_rightside() {
    # small adjustments
    
    right="$separator^bg() $nowplaying "
    right+="$separator^bg() $date $separator"
    
    right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
    # get width of right aligned text.. and add some space..
    width=$($textwidth "$font" "$right_text_only    ")
    echo -n "^pa($(($panel_width - $width)))$right"
    echo
}
