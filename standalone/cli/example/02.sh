#!/usr/bin/env bash

. ~/Documents/standalone/cli/example/ansi.sh
. ~/Documents/standalone/cli/example/helpercpu.sh
. ~/Documents/standalone/cli/example/progressbar.sh

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

initializeANSI

arrow="${boldOff}"

# hide cursor
tput civis  -- invisible
# type' tput cnorm' to show

clear

while :; do 
    helperCPU
    tput cup 0 0
    echo ""
      
    # cpu
    value=$cpu_util    
    progressbar $value  
    percent=$(printf "[ %3d%% ]" $value)
    
    diskText="${reset}"
    diskText+=" CPU    ${fgBlue}${boldOn}$percent${reset} "
    diskText+=$progressBarText
    echo -e "$diskText"
    
    # disk
    value=$(df /home -h | awk  'FNR == 2 {print $5}' | sed s/%//)    
    progressbar $value
    percent=$(printf "[ %3d%% ]" $value)
        
    diskText="${reset}"
    diskText+=" Disk   ${fgBlue}${boldOn}$percent${reset} "
    diskText+=$progressBarText
    echo -e "$diskText"
    
    # date time
    date=$(date +'%a %b %d')
    time=$(date +'%H:%M:%S')
    
    dateText="\n${reset} "
    dateText+="${bgRed}${fgWhite}${arrow}"
    dateText+="${bgRed}${fgWhite}${boldOn} ${date} "
    dateText+="${bgWhite}${fgRed}${arrow}"
    dateText+="${bgWhite}${fgRed} ${time} "
    dateText+="${reset}${fgWhite}${arrow}"
    dateText+="${reset}\n"
    echo -e "$dateText"
    
    # host
    
    value=$(uname -n)
    
    echo -e " ${fgRed}  ${reset}Host ${fgBlue}${boldOn}$value\n"

    sleep 2
done
