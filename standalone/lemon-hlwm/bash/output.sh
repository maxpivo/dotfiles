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

separator="%{B-}%{F${color['yellow500']}}|%{B-}%{F-}"

# Powerline Symbol
right_hard_arrow=""
right_soft_arrow=""
 left_hard_arrow=""
 left_soft_arrow=""

# theme
 pre_icon="%{F${color['yellow500']}}"
post_icon="%{F-}"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

function get_statusbar_text() {
    local monitor=$1
    local text=''

    # draw tags
    text+='%{l}'
    for tag_status in "${tags_status[@]}"
    do
        output_by_tag $monitor $tag_status
        text+=$buffer
    done
    
    # draw window title
    text+='%{r}'
    output_by_title    
    text+=$buffer
    
    buffer=$text
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

function output_by_tag() {
    local    monitor=$1    
    local tag_status=$2    
        
    local  tag_index=${tag_status:1:1}
    local   tag_mark=${tag_status:0:1}
    local   tag_name=${tag_shows[$tag_index - 1]}; # zero based

    # ----- pre tag

    local text_pre=''
    case $tag_mark in
        '#') text_pre+="%{B${color['blue500']}}%{F${color['black']}}"
             text_pre+="%{U${color['white']}}%{+u}$right_hard_arrow"
             text_pre+="%{B${color['blue500']}}%{F${color['white']}}"
             text_pre+="%{U${color['white']}}%{+u}"
        ;;
        '+') text_pre+="%{B${color['yellow500']}}%{F${color['grey400']}}"
        ;;
        ':') text_pre+="%{B-}%{F${color['white']}}"
             text_pre+="%{U${color['red500']}}%{+u}"
        ;;
        '!') text_pre+="%{B${color['red500']}}%{F${color['white']}}"
             text_pre+="%{U${color['white']}}%{+u}"
        ;;
        *)   text_pre+="%{B-}%{F${color['grey600']}}%{-u}"
        ;;
    esac

    # ----- tag by number
    
    # clickable tags
    local text_name=''
    text_name+="%{A:herbstclient focus_monitor \"$monitor\" && "
    text_name+="herbstclient use \"$tag_index\":} $tag_name %{A} "
  
    # non clickable tags
    # local text_name=" $tag_name "
    
    # ----- post tag

    local text_post=''
    if [ $tag_mark = '#' ]
    then        
        text_post+="%{B-}%{F${color['blue500']}}"
        text_post+="%{U${color['red500']}}%{+u}${right_hard_arrow}";
    fi
    
    text_clear='%{B-}%{F-}%{-u}'
     
    buffer="$text_pre$text_name$text_post$text_clear"
}

function output_by_title() {
    local text="$segment_windowtitle $separator  "
    buffer=$text
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

function set_tag_value() {
  # http://wiki.bash-hackers.org/commands/builtin/read
  # http://wiki.bash-hackers.org/syntax/shellvars#ifs
  # http://www.tldp.org/LDP/abs/html/x17837.html#HERESTRINGSREF
  IFS=$'\t' read -ra tags_status <<< "$(herbstclient tag_status $monitor)"
}

function set_windowtitle() {
    local windowtitle=$1
    local icon="$pre_icon$post_icon"
    # "${segmentWindowtitle//^/^^}"
    
    segment_windowtitle=" $icon %{B-}%{F${color['grey700']}} $windowtitle"
}
