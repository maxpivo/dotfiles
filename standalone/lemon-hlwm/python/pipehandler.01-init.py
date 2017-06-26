import os
import subprocess
import time

import output

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

def content_init(monitor, pipe_lemon_out):
    output.set_tag_value(monitor)
    output.set_windowtitle('')
        
    text = output.get_statusbar_text(monitor)
    pipe_lemon_out.stdin.write(text + '\n')
    pipe_lemon_out.stdin.flush()
    
def run_lemon(monitor, parameters):  
    command_out  = 'lemonbar ' + parameters + ' -p'

    pipe_lemon_out = subprocess.Popen(
            [command_out], 
            stdin  = subprocess.PIPE, # for use with content processing
            shell  = True,
            universal_newlines=True
        )

    content_init(monitor, pipe_lemon_out)
    pipe_lemon_out.stdin.close()

def detach_lemon(monitor, parameters):
    pid_lemon = os.fork()
    
    if pid_lemon == 0:
        try:
            run_lemon(monitor, parameters)
            os._exit(1)
        finally:
            import signal
            os.kill(pid_lemon, signal.SIGTERM)
