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
        title = column[2] if (len(column) > 2) else ''
        output.set_windowtitle(title)
    elif origin == 'interval':
        output.set_datetime()

def content_init(monitor, pipe_lemon_out):
    # initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')
    output.set_datetime()
        
    text = output.get_statusbar_text(monitor)
    pipe_lemon_out.stdin.write(text + '\n')
    pipe_lemon_out.stdin.flush()
    
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
                pipe_cat_out.stdin.write("interval\n")
                pipe_cat_out.stdin.flush()
    
                time.sleep(1)
        finally:
            import signal
            os.kill(pid_interval, signal.SIGTERM)

def content_walk(monitor, pipe_lemon_out): 
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
        pipe_lemon_out.stdin.write(text + '\n')
        pipe_lemon_out.stdin.flush()

    pipe_cat.stdin.close()
    pipe_cat.stdout.close()

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

def detach_lemon_debug(monitor, parameters):
    run_lemon(monitor, parameters)

def detach_lemon(monitor, parameters):
    # in case of debugging purpose, 
    # uncomment all the fork related lines.
    pid_lemon = os.fork()
    
    if pid_lemon == 0:
        try:
            run_lemon(monitor, parameters)
            os._exit(1)
        finally:
            import signal
            os.kill(pid_lemon, signal.SIGTERM)

def detach_lemon_conky(parameters):
    pid_conky = os.fork()
    
    if pid_conky == 0:
        try:
            dirname  = os.path.dirname(os.path.abspath(__file__))
            path     = dirname + "/../assets"
            cmd_in   = 'conky -c ' + path + '/conky.lua'

            cmd_out  = 'lemonbar ' + parameters

            pipe_out = subprocess.Popen(
                    [cmd_out], 
                    stdin  = subprocess.PIPE,
                    shell  = True,
                    universal_newlines=True
                )

            pipe_in  = subprocess.Popen(
                    [cmd_in], 
                    stdout = pipe_out.stdin,
                    stderr = subprocess.STDOUT,
                    shell  = True,
                    universal_newlines = True
                )

            pipe_out.stdin.close()
            outputs, errors = pipe_out.communicate()
    
            # avoid zombie apocalypse
            pipe_out.wait()

            os._exit(1)
        finally:
            import signal
            os.kill(pid_conky, signal.SIGTERM)
