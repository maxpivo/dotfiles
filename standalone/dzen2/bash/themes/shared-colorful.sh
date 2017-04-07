#!/usr/bin/env bash

theme_show() {
    local text=""

    text+="$separator $segmentVolume "
    text+="$separator $segmentCPU "
    text+="$separator $segmentMemory "
    text+="$separator $segmentDisk "
    text+="$separator $segmentSSID "
    text+="$separator $segmentNet "
  # text+="$separator $segmentUptime "     
  # text+="$separator $segmentHost "
  # text+="$separator $segmentUpdates "
  # text+="$separator $segmentDate "  
  # text+="$separator $segmentMPD "
    text+="$separator "
    
    echo -n $text
}
