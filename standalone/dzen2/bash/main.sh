#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

# Four themes: [ 'dark-colorful', 
#      'bright-colorful', 'dark-arrow', 'bright-arrow' ]

theme='bright-deco'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# include
. ~/Documents/standalone/dzen2/bash/gmc.sh
. ~/Documents/standalone/dzen2/bash/vars.sh
. ~/Documents/standalone/dzen2/bash/segments.sh
. ~/Documents/standalone/dzen2/bash/output.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all dzen2 instance
pkill dzen2

# execute dzen
generated_output | dzen2 $parameters &

sleep 1 && exec `(transset-df .8 -n dzentop >/dev/null 2>&1 &)` &



