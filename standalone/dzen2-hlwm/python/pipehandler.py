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

def init_content(monitor, pipe_out):
    # initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')
        
    text = output.get_statusbar_text(monitor)
    pipe_out.stdin.write(text + '\n')
    pipe_out.stdin.flush()

def walk_content(monitor, pipe_out):    
    # start a pipe
    command_in = 'herbstclient --idle'  
    pipe_in = subprocess.Popen(
            [command_in], 
            # stdout = pipe_out.stdin,
            stdout = subprocess.PIPE,
            stderr = subprocess.STDOUT,
            shell  = True,
            universal_newlines = True
        )
    
    # wait for each event  
    for event in pipe_in.stdout:  
        handle_command_event(monitor, event)
        
        text = output.get_statusbar_text(monitor)
        pipe_out.stdin.write(text)
        pipe_out.stdin.flush()
    
    pipe_in.stdout.close()
    
def run_dzen2(monitor, parameters):  
    command_out  = 'dzen2 ' + parameters

    pipe_out = subprocess.Popen(
            [command_out], 
            stdin  = subprocess.PIPE,
            shell  = True,
            universal_newlines=True
        )

    init_content(monitor, pipe_out)
    walk_content(monitor, pipe_out) # loop for each event

    pipe_out.stdin.close()
    outputs, errors = pipe_out.communicate()
    
    # avoid zombie apocalypse
    pipeout.wait()

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
