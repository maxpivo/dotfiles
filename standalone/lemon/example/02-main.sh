#!/usr/bin/env bash

# include
. ~/Documents/standalone/lemon/example/gmc.sh
. ~/Documents/standalone/lemon/example/02-output.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# parameters

# settings
position="640x24+0+0"
background="#aa$colWhite"
foreground="#ff$colBlack"

# XFT
# require lemonbar_xft_git 
font_symbol="PowerlineSymbols-10"
font_awesome="FontAwesome-10"
font_monospace="monospace-10"


generated_output | lemonbar \
    -g $position -u 2 -B $background -F $foreground \
    -f $font_monospace -f $font_awesome -f $font_symbol
  

