#!/usr/bin/env bash

output_by_tagmark() {
    $i=$1
    tagmark=${i:0:1}

    case $tagmark in
        '#') deco="^bg($colBlue500)^fg($colWhite)"     ;;
        '+') deco="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco="^bg()^fg($colWhite)"                ;;
        '!') deco="^bg($colRed500)^fg($colGrey900)"    ;;
        *)   deco="^bg()^fg($colGrey400)"        ;;
    esac
    
    echo -n $deco
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
        echo -n " ${key} "
    fi
}

rightside_space() {
    # small adjustments
    $right=$1

    right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
    # get width of right aligned text.. and add some space..
    width=$($textwidth "$font" "$right_text_only    ")
    echo -n "^pa($(($panel_width - $width)))"
}

output_leftside_top() {
    left=" $separator"
    left+="$segmentWindowtitle" 
    echo -n $left   
}

output_leftside_bottom() {
    left=" $separator $segmentVolume "
    left+="$separator $segmentMemory "
    left+="$separator $segmentDisk "
    left+="$separator $segmentCPU "
    left+="$separator $segmentNet "
    left+="$separator "
    echo -n $left
}

output_rightside_top() {
    right="$separator $segmentDate $separator"
    
    rightside_space $right
    echo -n $right
    echo
}

output_rightside_bottom() {   
    right=" $separator $segmentMPD "
    
    rightside_space $right
    echo -n $right
    echo
}
