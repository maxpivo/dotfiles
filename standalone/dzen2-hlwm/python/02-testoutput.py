#!/usr/bin/env python3
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

import os
import sys

import helper

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# process handler

def test_dzen2(monitor, parameters): 
    import subprocess
    import output
 
    command_out  = 'dzen2 ' + parameters + ' -p'

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
dzen2_parameters = helper.get_dzen2_parameters(monitor, panel_height)

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

# do `man herbsluftclient`, and type \pad to search what it means
os.system('herbstclient pad ' + str(monitor) + ' ' 
    + str(panel_height) + ' 0 ' + str(panel_height) + ' 0')

# run process
test_dzen2(monitor, dzen2_parameters);
