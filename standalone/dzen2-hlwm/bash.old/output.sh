#!/usr/bin/env bash


# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# custom tag names
tag_shows=( "一 ichi" "二 ni" "三 san" "四 shi" 
  "五 go" "六 roku" "七 shichi" "八 hachi" "九 kyū" "十 jū")

# initialize variable segment
segment_windowtitle='';
tags_status=();         # empty array

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

separator="^bg()^fg(${color['black']})|^bg()^fg()"

# Powerline Symbol
right_hard_arrow="^fn(powerlinesymbols-14)^fn()"
right_soft_arrow="^fn(powerlinesymbols-14)^fn()"
 left_hard_arrow="^fn(powerlinesymbols-14)^fn()"
 left_soft_arrow="^fn(powerlinesymbols-14)^fn()"

# http://fontawesome.io/
FontAwesome="^fn(FontAwesome-9)"

# theme
preIcon="^fg(${color['yellow500']})$FontAwesome"
postIcon="^fn()^fg()"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 panel parts

output_by_tagmark_pre() {
    $i=$1
    local tagmark=${i:0:1}
    local deco=""

    case $tagmark in
        '#') 
             deco+="^bg(${color['blue500']})^fg(${color['black']})"
             deco+=$right_hard_arrow
             deco+="^bg(${color['blue500']})^fg(${color['white']})"     
        ;;
        '+') deco+="^bg(${color['yellow500']})^fg(${color['grey400']})" 
        ;;
        ':') deco+="^bg()^fg(${color['white']})"
        ;;
        '!') deco+="^bg(${color['red500']})^fg(${color['white']})"
        ;;
        *)   deco+="^bg()^fg(${color['grey600']})"              
        ;;
    esac
    
    echo -n $deco
}

output_by_tagmark_post() {
    $i=$1
    local tagmark=${i:0:1}
    local deco=""

    case $tagmark in
        '#') 
             deco+="^bg(${color['black']})^fg(${color['blue500']})"
             deco+="$right_hard_arrow"
        ;;
        *) ;; # do nothing
    esac
    
    echo -n $deco
}

output_by_tagnumber() {
    i=$1
    
    local index=${i:1}-1
    local key=${tag_shows[$index]}

     # assuming using dzen2_svn
     # clickable tags if using SVN dzen
     echo -n "^ca(1,\"${herbstclient_command[@]:-herbstclient}\" "
     echo -n "focus_monitor \"$monitor\" && "
     echo -n "\"${herbstclient_command[@]:-herbstclient}\" "
     echo -n "use \"${i:1}\") ${key} ^ca() "
}

output_leftside_top() {
    local left=" ^r(5x0) $separator ^r(5x0) "
    left+="$segment_windowtitle" 
    echo -n $left 
    echo   
}
