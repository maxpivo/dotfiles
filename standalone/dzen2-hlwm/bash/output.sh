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
font_awesome="^fn(FontAwesome-9)"

# theme
pre_icon="^fg(${color['yellow500']})$font_awesome"
post_icon="^fn()^fg()"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

function get_statusbar_text() {
    local monitor=$1
    local text=''

    # draw tags
    for tag_status in "${tags_status[@]}"
    do
        output_by_tag $monitor $tag_status
        text+=$buffer
    done
    
    # draw window title
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
        '#') text_pre+="^bg(${color['blue500']})^fg(${color['black']})"
             text_pre+=$right_hard_arrow
             text_pre+="^bg(${color['blue500']})^fg(${color['white']})"     
        ;;
        '+') text_pre+="^bg(${color['yellow500']})^fg(${color['grey400']})" 
        ;;
        ':') text_pre+="^bg()^fg(${color['white']})"
        ;;
        '!') text_pre+="^bg(${color['red500']})^fg(${color['white']})"
        ;;
        *)   text_pre+="^bg()^fg(${color['grey600']})"              
        ;;
    esac

    # ----- tag by number
  
    # assuming using dzen2_svn
    # clickable tags if using SVN dzen
    local text_name=''
    text_name+="^ca(1,herbstclient focus_monitor \"$monitor\" && "
    text_name+="herbstclient use \"$tag_index\") $tag_name ^ca() "
    
    # ----- post tag

    local text_post=''
    if [ $tag_mark = '#' ]
    then
        text_post+="^bg(${color['black']})^fg(${color['blue500']})"
        text_post+=$right_hard_arrow;
    fi
     
    buffer="$text_pre$text_name$text_post"
}

function output_by_title() {
    local text=" ^r(5x0) $separator ^r(5x0) "
    text+="$segment_windowtitle" 
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
    
    segment_windowtitle=" $icon ^bg()^fg(${color['grey700']}) $windowtitle"      
}
