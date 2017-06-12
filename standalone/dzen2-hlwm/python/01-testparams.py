#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

import os
import sys

import helper

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = helper.get_monitor(sys.argv)

# do `man herbsluftclient`, and type \pad to search what it means
os.system('herbstclient pad ' + str(monitor) + ' ' 
    + str(panel_height) + ' 0 ' + str(panel_height) + ' 0')

dzen2_parameters = helper.get_dzen2_parameters(monitor, panel_height)
print(dzen2_parameters)
