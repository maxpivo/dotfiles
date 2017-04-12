#!/usr/bin/env bash

# https://github.com/marvins/Code_Sandbox/blob/master/bash/scripts/initializeANSI.bash

initializeANSI() {

    esc="\033" # If this doesn't work, enter an ESC directly
    # esc=""

    # Foreground Colors
    fgBlack="${esc}[30m";  fgRed="${esc}[31m";   fgGreen="${esc}[32m"
    fgYellow="${esc}[33m"; fgBlue="${esc}[34m";  fgPurple="${esc}[35m"
    fgCyan="${esc}[36m";   fgWhite="${esc}[37m";

    # Background Colors
    bgBlack="${esc}[40m";  bgRed="${esc}[41m";   bgGreen="${esc}[42m"
    bgYellow="${esc}[43m"; bgBlue="${esc}[44m";  bgPurple="${esc}[45m"
    bgCyan="${esc}[46m";   bgWhite="${esc}[47m";

    # Special Character Conditions
    boldOn="${esc}[1m";        boldOff="${esc}[22m"
    italicsOn="${esc}[3m";     italicsOff="${esc}[23m"
    underlineOn="${esc}[4m";   underlineOff="${esc}[24m"
    invertOn="${esc}[7m";      invertOff="${esc}[27m"

    # Reset to default configuration
    reset="${esc}[0m"
    
}
