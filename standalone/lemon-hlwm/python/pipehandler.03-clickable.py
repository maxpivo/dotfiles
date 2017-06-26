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
        os.system('pkill lemonbar')
    elif origin == 'quit_panel':
        exit()
    elif origin in tag_cmds:
        output.set_tag_value(monitor)
    elif origin in title_cmds:
        output.set_windowtitle(column[2])

def content_init(monitor, pipe_lemon_out):
    # initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')
        
    text = output.get_statusbar_text(monitor)
    pipe_lemon_out.stdin.write(text + '\n')
    pipe_lemon_out.stdin.flush()

def content_walk(monitor, pipe_lemon_out):    
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
    
    # wait for each event, trim newline 
    for event in pipe_idle_in.stdout:  
        handle_command_event(monitor, event.strip())
        
        text = output.get_statusbar_text(monitor)
        pipe_lemon_out.stdin.write(text + '\n')
        pipe_lemon_out.stdin.flush()
    
    pipe_idle_in.stdout.close()
    
def run_lemon(monitor, parameters):  
    command_out  = 'lemonbar ' + parameters

    pipe_lemon_out = subprocess.Popen(
            [command_out], 
            stdout = subprocess.PIPE, # for use with shell, note this
            stdin  = subprocess.PIPE, # for use with content processing
            shell  = True,
            universal_newlines=True
        )
    
    pipe_sh = subprocess.Popen(
            ['sh'], 
            stdin  = pipe_lemon_out.stdout,
            shell  = True,
            universal_newlines=True
        )

    content_init(monitor, pipe_lemon_out)
    content_walk(monitor, pipe_lemon_out) # loop for each event

    pipe_lemon_out.stdin.close()
    pipe_lemon_out.stdout.close()

def detach_lemon(monitor, parameters):
    pid_lemon = os.fork()
    
    if pid_lemon == 0:
        try:
            run_lemon(monitor, parameters)
            os._exit(1)
        finally:
            import signal
            os.kill(pid_lemon, signal.SIGTERM)
