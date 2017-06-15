#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in lemonbar

import os
import sys

import helper

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# process handler

def test_lemon(monitor, parameters): 
    import subprocess
    import output
 
    command_out  = 'lemonbar ' + parameters + ' -p'

    pipe_out = subprocess.Popen(
            [command_out], 
            stdin  = subprocess.PIPE,
            shell  = True,
            universal_newlines=True
        )

    # initialize statusbar
    output.set_tag_value(monitor)
    output.set_windowtitle('test')
        
    text = output.get_statusbar_text(monitor)
    pipe_out.stdin.write(text + '\n')
    pipe_out.stdin.flush()

    pipe_out.stdin.close()

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = helper.get_monitor(sys.argv)
lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

# do `man herbsluftclient`, and type \pad to search what it means
os.system('herbstclient pad ' + str(monitor) + ' ' 
    + str(panel_height) + ' 0 ' + str(panel_height) + ' 0')

# run process
test_lemon(monitor, lemon_parameters)
