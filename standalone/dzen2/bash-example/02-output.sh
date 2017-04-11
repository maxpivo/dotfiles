#!/usr/bin/env bash

# color, 
colWhite='#ffffff'
colBlack='#000000'

# also using google material
colRed500='#f44336'
colYellow500='#ffeb3b'
colBlue500='#2196f3'

generated_output() {
    # endless loop
    while :; do      
        local date=$(date +'%a %b %d')
        local time=$(date +'%H:%M:%S')

        local text=""
        text+="^bg($colBlue500)^fg($colYellow500)  $date  "
        text+="^bg()^fg()  "
        text+="^bg($colRed500)  $time  ^bg()"
      
        echo $text 
      
      sleep 1
    done
}
