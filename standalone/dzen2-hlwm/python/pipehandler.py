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
    elif origin == 'interval':
        output.set_datetime()

def content_init(monitor, pipe_dzen2_out):
    # initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')
    output.set_datetime()
        
    text = output.get_statusbar_text(monitor)
    pipe_dzen2_out.stdin.write(text + '\n')
    pipe_dzen2_out.stdin.flush()

def content_event_idle(pipe_cat_out):
    pid_idle = os.fork()
        
    if pid_idle == 0:
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
                pipe_cat_out.stdin.write(event)
                pipe_cat_out.stdin.flush()
    
            pipe_idle_in.stdout.close()
        finally:
            import signal
            os.kill(pid_idle, signal.SIGTERM)

def content_event_interval(pipe_cat_out):
    pid_interval = os.fork()

    if pid_interval == 0:
        try:
            while True:
                time_text = 'interval' + '\n';
    
                pipe_cat_out.stdin.write(time_text)
                pipe_cat_out.stdin.flush()
    
                time.sleep(1)
        finally:
            import signal
            os.kill(pid_interval, signal.SIGTERM)

def content_walk(monitor, pipe_dzen2_out): 
    pipe_cat = subprocess.Popen(
            ['cat'], 
            stdin  = subprocess.PIPE,
            stdout = subprocess.PIPE,
            shell  = True,
            universal_newlines=True
        )

    content_event_idle(pipe_cat)
    content_event_interval(pipe_cat)

    # wait for each event, trim newline
    for event in pipe_cat.stdout:
        handle_command_event(monitor, event.strip())

        text = output.get_statusbar_text(monitor)
        pipe_dzen2_out.stdin.write(text + '\n')
        pipe_dzen2_out.stdin.flush()
 
    pipe_cat.stdin.close()
    pipe_cat.stdout.close()
    
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
    # in case of debugging purpose, 
    # uncomment all the fork related lines.
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
