#!/usr/bin/env bash

# http://www.pavel-jiranek.net/simple-progress-bar-in-bash/ 

function progressbar() {

    value=$1
 
    # Default options.
    max=100
    width=25
    symbol="=" 

    # Compute the number of blocks to represent the percentage.
    num=$(( value * width / max ))
    
    # Create the progress bar string.
    bar=''
    if [ $num -gt 0 ]; then
        bar=$(printf "%0.s${symbol}" $(seq 1 $num))
    fi
    
    # Print the progress bar.
    line=$(printf "[%-${width}s]" "$bar")
    progressBarText="${line}\r"
}
