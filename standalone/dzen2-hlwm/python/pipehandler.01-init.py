import os
import subprocess
import time

import output

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

def content_init(monitor, pipe_dzen2_out):
    # initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')
        
    text = output.get_statusbar_text(monitor)
    pipe_dzen2_out.stdin.write(text + '\n')
    pipe_dzen2_out.stdin.flush()

def run_dzen2(monitor, parameters):  
    command_out  = 'dzen2 ' + parameters + ' -p'

    pipe_dzen2_out = subprocess.Popen(
            [command_out], 
            stdin  = subprocess.PIPE,
            shell  = True,
            universal_newlines=True
        )

    content_init(monitor, pipe_dzen2_out)
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
