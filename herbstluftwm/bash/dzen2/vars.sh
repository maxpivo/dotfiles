#!/usr/bin/env bash

tag_shows=( "一 ichi" "二 ni" "三 san" "四 shi" 
  "五 go" "六 roku" "七 shichi" "八 hachi" "九 kyū" "十 jū")
  
# Four themes: [ 'dark-colorful', 'bright-colorful', 'dark-arrow', 'bright-arrow' ]

theme='dark-arrow'

# initial
if [ -z $theme ]
then
    theme='dark-colorful'
fi

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# fonts

# I don't know, but rename font to font_top, give me memory faulty with textwidth
# https://en.wikipedia.org/wiki/X_logical_font_description
# https://wiki.archlinux.org/index.php/X_Logical_Font_Description
font_default="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
font_bottom="-*-terminus-bold-*-*-*-10-*-*-*-*-*-*-*"
font="-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen panel color

case $theme in
    'bright-colorful' | 'bright-arrow') 
        bgcolor=$colWhite
        fgcolor=$colBlack
    ;;
    *)  # 'dark-colorful' | 'dark-arrow' 
        bgcolor=$colBlack
        fgcolor=$colWhite
    ;;
esac

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

# Powerline Symbol
right_hard_arrow="^fn(powerlinesymbols-14)^fn()"
right_soft_arrow="^fn(powerlinesymbols-14)^fn()"
left_hard_arrow="^fn(powerlinesymbols-14)^fn()"
left_soft_arrow="^fn(powerlinesymbols-14)^fn()"

# http://fontawesome.io/
FontAwesome="^fn(FontAwesome-9)"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

case $theme in
    'bright-arrow') 

         #plain
         separator="^bg()^fg($colBlack)|^bg()^fg()"

         preIcon="^fg($colYellow500)$FontAwesome"
         postIcon="^fn()^fg()"
         labelColor="^fg($colGrey300)"
         valueColor="^fg($colGrey900)"
    ;;
    'dark-arrow')

         #plain
         separator="^bg()^fg($colWhite)|^bg()^fg()"

         preIcon="^fg($colYellow500)$FontAwesome"
         postIcon="^fn()^fg()"
         labelColor="^fg($colGrey900)"
         valueColor="^fg($colGrey100)"
    ;;
    'bright-colorful')

         #plain
         separator="^bg()^fg($colBlack)|^bg()^fg()"

         preIcon="^fg($colPink700)$FontAwesome"
         postIcon="^fn()^fg()"
         labelColor="^fg($colGrey700)"
         valueColor="^fg($colBlue700)"
    ;;
    *)  # 'dark-colorful'

         #plain
         separator="^bg()^fg($colWhite)|^bg()^fg()"

         preIcon="^fg($colYellow500)$FontAwesome"
         postIcon="^fn()^fg()"
         labelColor="^fg($colGrey700)"
         valueColor="^fg($colBlue300)"
    ;;
esac





  

