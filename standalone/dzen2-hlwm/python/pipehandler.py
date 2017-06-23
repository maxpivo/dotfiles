import os
import subprocess
import time

import output

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

def handle_command_event(monitor, event):  
    # find out event origin
    column = event.split("\t")
    origin = column[0]
    
    tag_cmds = ['tag_changed', 'tag_flags', 'tag_added', 'tag_removed']
    title_cmds = ['window_title_changed', 'focus_changed']

    if origin == 'reload':
        os.system('pkill dzen2')
    elif origin == 'quit_panel':
        exit()
    elif origin in tag_cmds:
        output.set_tag_value(monitor)
    elif origin in title_cmds:
        output.set_windowtitle(column[2])

def content_init(monitor, pipe_dzen2_out):
    # initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')
        
    text = output.get_statusbar_text(monitor)
    pipe_dzen2_out.stdin.write(text + '\n')
    pipe_dzen2_out.stdin.flush()

def content_walk(monitor, pipe_dzen2_out):
    # start a pipe
    command_in = 'herbstclient --idle'  
    pipe_idle_in = subprocess.Popen(
            [command_in], 
            # stdout = pipe_out.stdin,
            stdout = subprocess.PIPE,
            stderr = subprocess.STDOUT,
            shell  = True,
            universal_newlines = True
        )
    
    # wait for each event  
    for event in pipe_idle_in.stdout:  
        handle_command_event(monitor, event)
        
        text = output.get_statusbar_text(monitor)
        pipe_dzen2_out.stdin.write(text)
        pipe_dzen2_out.stdin.flush()
    
    pipe_idle_in.stdout.close()
    
def run_dzen2(monitor, parameters):  
    command_out  = 'dzen2 ' + parameters

    pipe_dzen2_out = subprocess.Popen(
            [command_out], 
            stdin  = subprocess.PIPE,
            shell  = True,
            universal_newlines=True
        )

    content_init(monitor, pipe_dzen2_out)
    content_walk(monitor, pipe_dzen2_out) # loop for each event

    pipe_dzen2_out.stdin.close()

def detach_dzen2(monitor, parameters):
    pid = os.fork()
    
    if pid == 0:
        try:
            run_dzen2(monitor, parameters)
            os._exit(1)
        finally:
            import signal
            os.kill(pid, signal.SIGTERM)

def detach_transset():
    pid = os.fork()
    
    if pid == 0:
        try:
            time.sleep(1)
            os.system('transset .8 -n dzentop >/dev/null')            
            os._exit(1)
        finally:
            import signal
            os.kill(pid, signal.SIGTERM)
