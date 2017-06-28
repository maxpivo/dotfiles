#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

import os
import sys

import helper
import pipehandler

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

panel_height = 24
monitor = helper.get_monitor(sys.argv)

os.system('pkill dzen2')
os.system('herbstclient pad ' + str(monitor) + ' ' 
    + str(panel_height) + ' 0 ' + str(panel_height) + ' 0')

# run process in the background

params_top    = helper.get_params_top(monitor, panel_height)
pipehandler.detach_dzen2(monitor, params_top)

params_bottom = helper.get_params_bottom(monitor, panel_height)
pipehandler.detach_dzen2_conky(params_bottom)

# optional transparency
pipehandler.detach_transset();
