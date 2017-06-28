#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in lemonbar

import os
import sys

import helper
import pipehandler

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

panel_height = 24
monitor = helper.get_monitor(sys.argv)

pipehandler.kill_zombie()
os.system('herbstclient pad ' + str(monitor) + ' ' 
    + str(panel_height) + ' 0 ' + str(panel_height) + ' 0')

# run process in the background

params_top    = helper.get_params_top(monitor, panel_height)
pipehandler.detach_lemon(monitor, params_top)

params_bottom = helper.get_params_bottom(monitor, panel_height)
pipehandler.detach_lemon_conky(params_bottom)
