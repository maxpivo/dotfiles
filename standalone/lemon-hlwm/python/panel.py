#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

import os
import sys

import helper
import pipehandler

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = helper.get_monitor(sys.argv)

# do `man herbsluftclient`, and type \pad to search what it means
os.system('herbstclient pad ' + str(monitor) + ' ' 
    + str(panel_height) + ' 0 ' + str(panel_height) + ' 0')

lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all lemonbar instance
os.system('pkill lemon')

# run process in the background
pipehandler.detach_lemon(monitor, lemon_parameters);
