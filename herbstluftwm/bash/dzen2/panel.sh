#!/usr/bin/env bash

hc() { "${herbstclient_command[@]:-herbstclient}" "$@" ;}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

# Four themes: [ 'dark-colorful', 'bright-colorful', 'dark-arrow', 'bright-arrow' ]

theme='bright-arrow'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# geometry calculation

monitor=${1:-0}
geometry=( $(herbstclient monitor_rect "$monitor") )
if [ -z "$geometry" ] ;then
    echo "Invalid monitor $monitor"
    exit 1
fi

# geometry has the format W H X Y
x=${geometry[0]}
y=${geometry[1]}
panel_width=${geometry[2]}
panel_height=24

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# google material colors

. ~/.config/herbstluftwm/bash/assets/gmc.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# libraries

. ~/.config/herbstluftwm/bash/dzen2/vars.sh
. ~/.config/herbstluftwm/bash/dzen2/helper.sh
. ~/.config/herbstluftwm/bash/dzen2/segments.sh
. ~/.config/herbstluftwm/bash/dzen2/output.sh
. ~/.config/herbstluftwm/bash/dzen2/generate.sh

init_theme
init_segments

# do `man herbsluftclient`, and type \pad to search what it means
hc pad $monitor $panel_height 0 $panel_height 0

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen Parameters

dzen2_top_parameters="  -x $x -y $y -w $panel_width -h 24" 
dzen2_top_parameters+=" -fn $font"
dzen2_top_parameters+=" -ta l -bg $bgcolor -fg $fgcolor"
dzen2_top_parameters+=" -title-name dzentop"

dzen2_bottom_parameters="  -x $x -y -24 -w $panel_width -h 24" 
dzen2_bottom_parameters+=" -fn $font_bottom"
dzen2_bottom_parameters+=" -ta l -bg $bgcolor -fg $fgcolor"
dzen2_bottom_parameters+=" -title-name dzenbottom"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# By redirecting stderr to /dev/null, you effectively suppress these messages.
# 2> /dev/null

event_generator_top 2> /dev/null | generated_output_top 2> /dev/null | dzen2 $dzen2_top_parameters \
   -e 'button3=;button4=exec:herbstclient use_index -1;button5=exec:herbstclient use_index +1' &

event_generator_bottom 2> /dev/null | generated_output_bottom 2> /dev/null | dzen2 $dzen2_bottom_parameters &

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# optional transparency

# https://github.com/wildefyr/transset-df
# sleep 1 && exec `(transset-df .8 -n dzenbottom >/dev/null 2>&1 &)` &
# sleep 2 && exec `(transset-df .8 -n dzentop >/dev/null 2>&1 &)` &

# you may use xorg-transset instead of transset-df
sleep 1 && exec `(transset .8 -n dzenbottom >/dev/null 2>&1 &)` &
sleep 2 && exec `(transset .8 -n dzentop >/dev/null 2>&1 &)` &
