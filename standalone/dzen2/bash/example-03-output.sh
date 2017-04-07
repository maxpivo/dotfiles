#!/usr/bin/env bash

# color, 
colWhite='#ffffff'
colBlack='#000000'

# also using google material
colRed500='#f44336'
colYellow500='#ffeb3b'
colBlue500='#2196f3'
colGrey500='#9e9e9e'

# http://fontawesome.io/
FontAwesome="^fn(FontAwesome-9)"

# icon 
preIcon="^fg($colYellow500)$FontAwesome"
postIcon="^fn()^fg()"

# Powerline Symbol
arrow="^fn(powerlinesymbols-14)^fn()"


generated_output() {
    local iconDate="$preIcon$postIcon"
    local iconTime="$preIcon$postIcon"

    # endless loop
    while :; do   
        local date=$(date +'%a %b %d')
        local time=$(date +'%H:%M:%S')
        
        local text=""
        text+="^bg($colBlue500)^fg($colWhite)$arrow "
        text+="^bg($colBlue500) $iconDate ^fg()  $date  "
        text+="^bg($colWhite)^fg($colBlue500)$arrow "
        text+="^bg()^fg()  "
        text+="^bg($colRed500)^fg($colWhite)$arrow "
        text+="^bg($colRed500) $iconTime ^fg() $time  ^bg()"
        text+="^bg($colWhite)^fg($colRed500)$arrow "
             
        echo -n $text 
        echo
      
      sleep 1
    done
}
