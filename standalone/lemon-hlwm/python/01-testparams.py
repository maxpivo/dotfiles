#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in lemonbar

import sys
import helper

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = helper.get_monitor(sys.argv)

lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)
print(lemon_parameters)
