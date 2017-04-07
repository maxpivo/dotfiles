#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# fonts

# I don't know, but rename font to font_top, give me memory faulty with textwidth
# https://en.wikipedia.org/wiki/X_logical_font_description
# https://wiki.archlinux.org/index.php/X_Logical_Font_Description
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"

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

# Four themes: [ 'dark-colorful', 
#    'bright-colorful', 'dark-arrow', 'bright-arrow' ]

# initial
if [ -z $theme ]
then
    theme='dark-colorful'
    
    # dzen panel color
    bgcolor=$colBlack
    fgcolor=$colWhite
    alignment="c"
fi

init_theme() { 

    theme_config_default=~/Documents/standalone/dzen2/bash/themes/dark-colorful.sh
    theme_config=~/Documents/standalone/dzen2/bash/themes/${theme}.sh

    [ -x "$theme_config" ] || theme_config=$theme_config_default

    . $theme_config
}

init_theme

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen2 parameters

xpos=0
ypos=0
width=640
height=24
font="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"

parameters="  -x $xpos -y $ypos -w $width -h $height" 
parameters+=" -fn $font"
parameters+=" -ta $alignment -bg $bgcolor -fg $fgcolor"
parameters+=" -title-name dzentop"
