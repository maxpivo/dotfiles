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

# Glyph Icon Decoration
decopath="Documents/standalone/dzen2/assets/xbm"

# diagonal corner
deco_dc_tl="^i($decopath/dc-024-tl.xbm)"
deco_dc_tr="^i($decopath/dc-024-tr.xbm)"
deco_dc_bl="^i($decopath/dc-024-bl.xbm)"
deco_dc_br="^i($decopath/dc-024-br.xbm)"

# single arrow and double arrow
deco_sa_l="^i($decopath/sa-024-l.xbm)"
deco_sa_r="^i($decopath/sa-024-r.xbm)"
deco_da_l="^i($decopath/da-024-l.xbm)"
deco_da_r="^i($decopath/da-024-r.xbm)"

generated_output() {
    local iconDate="$preIcon$postIcon"
    local iconTime="$preIcon$postIcon"

    # endless loop
    while :; do   
        local date=$(date +'%a %b %d')
        local time=$(date +'%H:%M:%S')
        
        local text=""
        text+="^bg($colBlue500)^fg($colWhite)$deco_dc_tl "
        text+="^bg($colBlue500) $iconDate ^fg()  $date  "
        text+="^bg($colWhite)^fg($colBlue500)$deco_da_r"
        text+="^bg()^fg() "
        text+="^bg($colWhite)^fg($colRed500)$deco_da_l"
        text+="^bg($colRed500) $iconTime ^fg() $time  ^bg()"
        text+="^bg($colWhite)^fg($colRed500)$deco_dc_bl "
             
        echo -n $text 
        echo
      
      sleep 1
    done
}
