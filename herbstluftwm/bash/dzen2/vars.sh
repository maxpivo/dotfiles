#!/usr/bin/env bash

tag_shows=( "一 ichi" "二 ni" "三 san" "四 shi" 
  "五 go" "六 roku" "七 shichi" "八 hachi" "九 kyū" "十 jū")

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# fonts

# I don't know, but rename font to font_top, give me memory faulty with textwidth
# https://en.wikipedia.org/wiki/X_logical_font_description
# https://wiki.archlinux.org/index.php/X_Logical_Font_Description
font_default="-*-fixed-medium-*-*-*-12-*-*-*-*-*-*-*"
font_bottom="-*-terminus-bold-*-*-*-10-*-*-*-*-*-*-*"
font="-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# colors

bgcolor=$colGrey900
fgcolor=$colGrey500
  
separator="^bg()^fg($colYellow500)|^bg()^fg()"
