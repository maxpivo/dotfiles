#!/usr/bin/env bash

generated_output() {

    # endless loop
    while :; do   
      
      # initialize segment value
        setVolume
        setCPU
        setMemory
        setDisk
        setSSID
        setNet
      # setUptime
      # setHost
      # setUpdates
      # setDate
      # setMPD

        theme_show
             
        echo -n $text 
        echo
      
      sleep 1
    done
}
