#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

import sys
import helper

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = helper.get_monitor(sys.argv)

dzen2_parameters = helper.get_dzen2_parameters(monitor, panel_height)
print(dzen2_parameters)
