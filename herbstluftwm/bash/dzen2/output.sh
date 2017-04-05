#!/usr/bin/env bash

init_theme() {  
    case $theme in
      'bright-arrow')
         . ~/.config/herbstluftwm/bash/dzen2/themes/bright-arrow.sh
      ;;
      'dark-arrow')
         . ~/.config/herbstluftwm/bash/dzen2/themes/dark-arrow.sh
      ;;
      'bright-colorful')
         . ~/.config/herbstluftwm/bash/dzen2/themes/bright-colorful.sh
      ;;
      *)  # 'dark-colorful'
         . ~/.config/herbstluftwm/bash/dzen2/themes/dark-colorful.sh
      ;;
    esac    
}


output_by_tagmark_pre() {
    $i=$1
    local tagmark=${i:0:1}
    theme_tagmark_pre $tagmark
}

output_by_tagmark_post() {
    $i=$1
    local tagmark=${i:0:1}
    theme_tagmark_post $tagmark
}

output_by_tagnumber() {
    i=$1
    
    local index=${i:1}-1
    local key=${tag_shows[$index]}
    if [ ! -z "$dzen2_svn" ] ; then
        # clickable tags if using SVN dzen
        echo -n "^ca(1,\"${herbstclient_command[@]:-herbstclient}\" "
        echo -n "focus_monitor \"$monitor\" && "
        echo -n "\"${herbstclient_command[@]:-herbstclient}\" "
        echo -n "use \"${i:1}\") ${key} ^ca() "
    else
        # non-clickable tags if using older dzen
        echo -n " ${key} "
    fi
}

rightside_space() {    
    # small adjustments
    local adjustment=$1
    
    #using global $right    
    local right_text_only=$(echo -n "$right" | sed 's.\^[^(]*([^)]*)..g')
    
    # get width of right aligned text.. and add some space..
    local width=$($textwidth "$font" "$right_text_only    ")
    echo -n "^pa($(($panel_width - $width -$adjustment)))"
}

output_leftside_top() {
    local left=" ^r(5x0) $separator ^r(5x0) "
    left+="$segmentWindowtitle" 
    echo -n $left   
}

output_rightside_top() {
    theme_rightside_top
}

output_leftside_bottom() {
    theme_leftside_bottom
}

output_rightside_bottom() { 
    theme_rightside_bottom
}
