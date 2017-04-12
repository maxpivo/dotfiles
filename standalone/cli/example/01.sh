#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# for use with 'watch --color'

esc="\033"

      fgRed="${esc}[31m"
     fgBlue="${esc}[34m"
    fgWhite="${esc}[37m"
     bgRed="${esc}[41m"
     bgBlue="${esc}[44m"
    bgWhite="${esc}[47m"
complexBlue="${esc}[1;3;4;34m"
     boldOn="${esc}[1m"
    boldOff="${esc}[22m"
      reset="${esc}[0m"
     
date=$(date +'%a %b %d')
time=$(date +'%H:%M:%S')

arrow="${boldOff}"
awesome='                   '

text=""
text+="${fgBlue} ${date} "
text+="${complexBlue} ${time}"
text+="${reset}\n"
text+="${awesome}"
text+="${reset}\n"
text+="${bgBlue}${fgWhite}${arrow}"
text+="${bgBlue}${fgWhite}${boldOn} Right "
text+="${bgRed}${fgBlue}${arrow}"
text+="${bgRed}${fgWhite}${boldOn} Arrow "
text+="${reset}${fgRed}${arrow}"
text+="\n"

echo -e $text
