#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in lemonbar

import os
import sys

import helper
import pipehandler

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = helper.get_monitor(sys.argv)
lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)

# do `man herbsluftclient`, and type \pad to search what it means
os.system('herbstclient pad ' + str(monitor) + ' ' 
    + str(panel_height) + ' 0 ' + str(panel_height) + ' 0')

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all lemonbar instance
os.system('pkill lemonbar')

# run process in the background
pipehandler.detach_lemon(monitor, lemon_parameters)
