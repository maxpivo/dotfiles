#!/usr/bin/env bash

output_by_tagmark_pre() {
    $i=$1
    local tagmark=${i:0:1}
    
    case $theme in
      'bright-arrow')
         theme_tagmark_pre_bright_right_arrow $tagmark
      ;;
      'dark-arrow')
         theme_tagmark_pre_dark_right_arrow $tagmark
      ;;
      'bright-colorful')
         theme_tagmark_pre_bright_colorful $tagmark
      ;;
      *)  # 'dark-colorful'
         theme_tagmark_pre_dark_colorful $tagmark
      ;;
    esac    
}

output_by_tagmark_post() {
    $i=$1
    local tagmark=${i:0:1}
    
    case $theme in
      'bright-arrow')
         theme_tagmark_post_bright_right_arrow $tagmark
      ;;
      'dark-arrow')
         theme_tagmark_post_dark_right_arrow $tagmark
      ;;
      *)  # 'dark-colorful' | 'bright-colorful'
      ;;
    esac    
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
    case $theme in
      'bright-arrow') 
         theme_rightside_top_bright_left_arrow
      ;;
      'dark-arrow')
         theme_rightside_top_dark_left_arrow
      ;;
      *) # 'dark-colorful' | 'bright-colorful'
         theme_rightside_top_colorful
      ;;
    esac 
}

output_leftside_bottom() {
    case $theme in
      'bright-arrow') 
         theme_leftside_bottom_bright_right_arrow
      ;;
      'dark-arrow')
         theme_leftside_bottom_dark_right_arrow
      ;;
      *) # 'dark-colorful' | 'bright-colorful'
         theme_leftside_bottom_colorful
      ;;
    esac   
}

output_rightside_bottom() { 
    case $theme in
      'bright-arrow') 
         theme_rightside_bottom_bright_left_arrow
      ;;
      'dark-arrow')
         theme_rightside_bottom_dark_left_arrow
      ;;
      *) # 'dark-colorful' | 'bright-colorful'
         theme_rightside_bottom_colorful
      ;;
    esac  
}

theme_tagmark_pre_dark_colorful() {
    local deco
    local tagmark=$1

    case $tagmark in
        '#') deco="^bg($colBlue500)^fg($colWhite)"     ;;
        '+') deco="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco="^bg()^fg($colWhite)"                ;;
        '!') deco="^bg($colRed500)^fg($colWhite)"      ;;
        *)   deco="^bg()^fg($colGrey600)"              ;;
    esac
    
    echo -n $deco
}

theme_tagmark_pre_bright_colorful() {
    local deco
    local tagmark=$1

    case $tagmark in
        '#') deco="^bg($colBlue500)^fg($colBlack)"     ;;
        '+') deco="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco="^bg()^fg($colBlack)"                ;;
        '!') deco="^bg($colRed500)^fg($colBlack)"      ;;
        *)   deco="^bg()^fg($colGrey600)"              ;;
    esac
    
    echo -n $deco
}

theme_tagmark_pre_bright_right_arrow() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg($colBlue500)^fg($colWhite)$right_hard_arrow"
             deco+="^bg($colBlue500)^fg($colBlack)"     
        ;;
        '+') deco+="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco+="^bg()^fg($colBlack)"                ;;
        '!') deco+="^bg($colRed500)^fg($colBlack)"      ;;
        *)   deco+="^bg()^fg($colGrey600)"              ;;
    esac
    
    echo -n $deco
}

theme_tagmark_pre_dark_right_arrow() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg($colBlue500)^fg($colBlack)$right_hard_arrow"
             deco+="^bg($colBlue500)^fg($colWhite)"     
        ;;
        '+') deco="^bg($colYellow500)^fg($colGrey400)" ;;
        ':') deco="^bg()^fg($colWhite)"                ;;
        '!') deco="^bg($colRed500)^fg($colWhite)"      ;;
        *)   deco="^bg()^fg($colGrey600)"              ;;
    esac
    
    echo -n $deco
}

theme_tagmark_post_bright_right_arrow() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg($colWhite)^fg($colBlue500)$right_hard_arrow"
        ;;
        *) ;; # do nothing
    esac
    
    echo -n $deco
}

theme_tagmark_post_dark_right_arrow() {
    local deco=""
    local tagmark=$1

    case $tagmark in
        '#') 
             deco+="^bg($colBlack)^fg($colBlue500)$right_hard_arrow"
        ;;
        *) ;; # do nothing
    esac
    
    echo -n $deco
}

theme_leftside_bottom_colorful() {
    local left=" $separator $segmentHost "
    left+="$separator $segmentVolume "
    left+="$separator $segmentMemory "
    left+="$separator $segmentDisk "
    left+="$separator $segmentCPU "
    left+="$separator $segmentSSID "
    left+="$separator $segmentNet "
  # left+="$separator $segmentUpdates "
    left+="$separator "
    echo -n $left
}

theme_leftside_bottom_bright_right_arrow() {
    local left=""
    left+=" ^fg($colRed900)^bg($colRed800)$right_hard_arrow"
    left+=" $segmentHost "
    left+=" ^fg($colRed800)^bg($colRed700)$right_hard_arrow"
    left+=" $segmentVolume "
    left+=" ^fg($colRed700)^bg($colRed600)$right_hard_arrow"
    left+=" $segmentMemory "
    left+=" ^fg($colRed600)^bg($colRed500)$right_hard_arrow"
    left+=" $segmentDisk "
    left+=" ^fg($colRed500)^bg($colRed400)$right_hard_arrow"
    left+=" $segmentCPU "
    left+=" ^fg($colRed400)^bg($colRed300)$right_hard_arrow"
    left+=" $segmentSSID "
    left+=" ^fg($colRed300)^bg($colRed200)$right_hard_arrow"
    left+=" $segmentNet "
    left+=" ^fg($colRed200)^bg($colRed100)$right_hard_arrow"
  # left+=" $segmentUpdates "
    left+=" ^fg($colRed100)^bg($colWhite)$right_hard_arrow"

    echo -n $left
}

theme_leftside_bottom_dark_right_arrow() {
    local left=""
    left+=" ^fg($colBlue100)^bg($colBlue200)$right_hard_arrow"
    left+=" $segmentHost "
    left+=" ^fg($colBlue200)^bg($colBlue300)$right_hard_arrow"
    left+=" $segmentVolume "
    left+=" ^fg($colBlue300)^bg($colBlue400)$right_hard_arrow"
    left+=" $segmentMemory "
    left+=" ^fg($colBlue400)^bg($colBlue500)$right_hard_arrow"
    left+=" $segmentDisk "
    left+=" ^fg($colBlue500)^bg($colBlue600)$right_hard_arrow"
    left+=" $segmentCPU "
    left+=" ^fg($colBlue600)^bg($colBlue700)$right_hard_arrow"
    left+=" $segmentSSID "
    left+=" ^fg($colBlue700)^bg($colBlue800)$right_hard_arrow"
    left+=" $segmentNet "
    left+=" ^fg($colBlue800)^bg($colBlue900)$right_hard_arrow"
  # left+=" $segmentUpdates "
    left+=" ^fg($colBlue900)^bg($colBlack)$right_hard_arrow"

    echo -n $left
}


theme_rightside_top_colorful() {
    # do not local $right
    right="$separator $segmentDate $separator"
    
    rightside_space 0
    echo -n $right
    echo
}

theme_rightside_top_bright_left_arrow() {
    # do not local $right
    right=""
    right+="^fg($colRed100)^bg($colWhite)$left_hard_arrow"
    right+="^bg($colRed100) "
    right+="^fg($colRed200)^bg($colRed100)$left_hard_arrow"
    right+="^bg($colRed200) "
    right+="^fg($colRed300)^bg($colRed200)$left_hard_arrow"
    right+="^bg($colRed300) "
    right+="^fg($colRed400)^bg($colRed300)$left_hard_arrow"
    right+="^bg($colRed400) "
    right+="^fg($colRed500)^bg($colRed400)$left_hard_arrow"
    right+="^bg($colRed500) "
    right+="^fg($colRed600)^bg($colRed500)$left_hard_arrow"
    right+="^bg($colRed600) "
    right+="^fg($colRed700)^bg($colRed600)$left_hard_arrow"    
    right+="^bg($colRed700) "
    right+="^fg($colRed800)^bg($colRed700)$left_hard_arrow"
    right+="^bg($colRed800)$segmentDate "
    right+="^fg($colRed900)^bg($colRed800)$left_hard_arrow"
    right+="^bg($colRed900)     ."
    
    rightside_space 0
    echo -n $right
    echo
}

theme_rightside_top_dark_left_arrow() {
    # do not local $right
    right=""
    right+="^fg($colBlue600)^bg($colBlack) $left_hard_arrow"    
    right+="^bg($colBlue600) "
    right+="^fg($colBlack)^bg($colBlue600) $left_hard_arrow"
    right+="^bg($colBlack)$segmentDate "
    right+="^fg($colBlue400)^bg($colBlack) $left_hard_arrow"
    right+="^bg($colBlue400)     ."
    
    rightside_space -10
    echo -n $right
    echo
}

theme_rightside_bottom_colorful() { 
    # do not local $right
    right=""
    right+="$separator $segmentUptime "  
    right+="$separator $segmentMPD "
    right+="$separator "
    
    rightside_space 10
    echo -n $right
    echo
}

theme_rightside_bottom_bright_left_arrow() {
    # do not local $right
    right=""
    right+="^fg($colRed100)^bg($colWhite)$left_hard_arrow"
    right+="^bg($colRed100) "
    right+="^fg($colRed200)^bg($colRed100)$left_hard_arrow"
    right+="^bg($colRed200) "
    right+="^fg($colRed300)^bg($colRed200)$left_hard_arrow"
    right+="^bg($colRed300) "
    right+="^fg($colRed400)^bg($colRed300)$left_hard_arrow"
    right+="^bg($colRed400) "
    right+="^fg($colRed500)^bg($colRed400)$left_hard_arrow"
    right+="^bg($colRed500) "
    right+="^fg($colRed600)^bg($colRed500)$left_hard_arrow"
    right+="^bg($colRed600) "
    right+="^fg($colRed700)^bg($colRed600)$left_hard_arrow"    
    right+="^bg($colRed700)$segmentUptime "
    right+="^fg($colRed800)^bg($colRed700)$left_hard_arrow"
    right+="^bg($colRed800)$segmentMPD "
    right+="^fg($colRed900)^bg($colRed800)$left_hard_arrow"
    right+="^bg($colRed900)     ."
    
    rightside_space 0
    echo -n $right
    echo
}


theme_rightside_bottom_dark_left_arrow() {
    # do not local $right
    right=""
    right+="^fg($colBlue900)^bg($colBlack)$left_hard_arrow"
    right+="^bg($colBlue900)$segmentUptime "
    right+="^fg($colBlue800)^bg($colBlue900)$left_hard_arrow"
    right+="^bg($colBlue800) "
    right+="^fg($colBlue700)^bg($colBlue800)$left_hard_arrow"
    right+="^bg($colBlue700) "
    right+="^fg($colBlue600)^bg($colBlue700)$left_hard_arrow"
    right+="^bg($colBlue600) "
    right+="^fg($colBlue500)^bg($colBlue600)$left_hard_arrow"
    right+="^bg($colBlue500) "
    right+="^fg($colBlue400)^bg($colBlue500)$left_hard_arrow"
    right+="^bg($colBlue400) "
    right+="^fg($colBlue300)^bg($colBlue400)$left_hard_arrow"    
    right+="^bg($colBlue300) "
    right+="^fg($colBlack)^bg($colBlue300)$left_hard_arrow"
    right+="^bg($colBlack)$segmentMPD "
    right+="^fg($colBlue100)^bg($colBlack)$left_hard_arrow"
    right+="^bg($colBlue100)     ."
    
    rightside_space 0
    echo -n $right
    echo
}

