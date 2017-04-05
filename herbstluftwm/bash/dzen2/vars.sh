#!/usr/bin/env bash

tag_shows=( "一 ichi" "二 ni" "三 san" "四 shi" 
  "五 go" "六 roku" "七 shichi" "八 hachi" "九 kyū" "十 jū")
  
# Four themes: [ 'dark-colorful', 'bright-colorful', 'dark-arrow', 'bright-arrow' ]

theme='bright-arrow'

# initial
if [ -z $theme ]
then
    theme='dark-colorful'
    
    # dzen panel color
    bgcolor=$colBlack
    fgcolor=$colWhite
    
    # default theme
    separator="^bg()^fg($colWhite)|^bg()^fg()"

    preIcon="^fg($colYellow500)$FontAwesome"
    postIcon="^fn()^fg()"
    labelColor="^fg($colGrey700)"
    valueColor="^fg($colBlue300)"
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
# decoration

# Powerline Symbol
right_hard_arrow="^fn(powerlinesymbols-14)^fn()"
right_soft_arrow="^fn(powerlinesymbols-14)^fn()"
left_hard_arrow="^fn(powerlinesymbols-14)^fn()"
left_soft_arrow="^fn(powerlinesymbols-14)^fn()"

# http://fontawesome.io/
FontAwesome="^fn(FontAwesome-9)"





  

