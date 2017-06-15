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
dzen2_parameters = helper.get_dzen2_parameters(monitor, panel_height)

# do `man herbsluftclient`, and type \pad to search what it means
os.system('herbstclient pad ' + str(monitor) + ' ' 
    + str(panel_height) + ' 0 ' + str(panel_height) + ' 0')

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all dzen2 instance
os.system('pkill dzen2')

# run process in the background
pipehandler.detach_dzen2(monitor, dzen2_parameters);

# optional transparency
pipehandler.detach_transset();
