#!/usr/bin/env bash

theme_leftside_bottom() {
    local left=" $separator $segmentHost "
    left+="$separator $segmentVolume "
    left+="$separator $segmentMemory "
    left+="$separator $segmentDisk "
    left+="$separator $segmentCPU "
    left+="$separator $segmentSSID "
    left+="$separator $segmentNet "
  # left+="$separator $segmentUpdates "
    left+="$separator "
    echo -n $left
}

theme_rightside_top() {
    # do not local $right
    right="$separator $segmentDate $separator"
    
    rightside_space 0
    echo -n $right
    echo
}

theme_rightside_bottom() { 
    # do not local $right
    right=""
    right+="$separator $segmentUptime "  
    right+="$separator $segmentMPD "
    right+="$separator "
    
    rightside_space 10
    echo -n $right
    echo
}
