#!/usr/bin/env bash

# Char glyps for powerline fonts
   sep_left=""    # Powerline separator left
  sep_right=""    # Powerline separator right
 sep_l_left=""    # Powerline light separator left
sep_l_right=""    # Powerline light sepatator right

homeicon_awesome=''

generated_output() {
    # endless loop
    while :; do      
        local date=$(date +'%a %b %d')
        local time=$(date +'%H:%M:%S')

        local text=""

        text+="%{r} "
        text+="%{B-}%{F-}%{-u}"
        text+="$homeicon_awesome "
        
        # Lemon Feature
        # Font Test using XFT
        text+="%{c}"
        text+="%{B-}%{F-}%{-u}  "
        text+="%{B#cc$colBlue500}%{U#$colGrey900}%{+u}"
        text+="%{F#$colBlue800} $sep_right"
        text+="%{F#$colGrey900} "
        text+="%{F#$colGrey200} $date  "
        text+="%{B-}%{F-}%{-u}"
        text+="%{B#cc$colGreen500}%{U#$colGrey200}%{+u}"
        text+="%{F#$colGreen200} $sep_right"
        text+="%{F#$colGrey200} "
        text+="%{F#$colGrey900} $time  "
        text+="%{B-}%{F-}%{-u}  "
        
        echo $text 
      
      sleep 1
    done
}
