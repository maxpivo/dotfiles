#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in lemonbar

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

lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)
print(lemon_parameters)
