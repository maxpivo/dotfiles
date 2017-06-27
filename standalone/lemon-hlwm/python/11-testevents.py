#!/usr/bin/env python3

import os
import subprocess

import datetime
import time

def content_event_idle(cat_out):
    pid = os.fork()
    
    if pid == 0:
        try:
            # start a pipe
            command_in = 'herbstclient --idle'  
            pipe_idle_in = subprocess.Popen(
                    [command_in], 
                    stdout = subprocess.PIPE,
                    stderr = subprocess.STDOUT,
                    shell  = True,
                    universal_newlines = True
            )

            # wait for each event  
            for event in pipe_idle_in.stdout: 
                cat_out.stdin.write(event)
                cat_out.stdin.flush()
    
            pipe_idle_in.stdout.close()
        finally:
            import signal
            os.kill(pid, signal.SIGTERM)


def content_event_interval(cat_out):
    pid = os.fork()
    
    if pid == 0:
        try:
            timeformat = '{0:%H:%M:%S}'

            while True:
                time_str  = timeformat.format(datetime.datetime.now())
                time_text = 'interval' + '\t' + time_str + '\n';
    
                cat_out.stdin.write(time_text)
                cat_out.stdin.flush()
    
                time.sleep(3)

            # cat_out.wait()    
        finally:
            import signal
            os.kill(pid, signal.SIGTERM)

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

pipe_cat = subprocess.Popen(
        ['cat'], 
        stdin  = subprocess.PIPE,
        stdout = subprocess.PIPE,
        shell  = True,
        universal_newlines=True
    )

content_event_idle(pipe_cat)
content_event_interval(pipe_cat)

for event in pipe_cat.stdout:
    print('event:\t[' + event.strip() +']')

pipe_cat.stdin.close()
pipe_cat.stdout.close()
