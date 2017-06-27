import os
import subprocess
import time

import output

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

def content_init(monitor, pipe_dzen2_out):
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

def detach_dzen2_debug(monitor, parameters):
    run_lemon(monitor, parameters)

def detach_dzen2(monitor, parameters):
    # in case of debugging purpose, 
    # uncomment all the fork related lines.
    pid_dzen2 = os.fork()
    
    if pid_dzen2 == 0:
        try:
            run_dzen2(monitor, parameters)
            os._exit(1)
        finally:
            import signal
            os.kill(pid_dzen2, signal.SIGTERM)

def detach_transset():
    pid_transset = os.fork()
    
    if pid_transset == 0:
        try:
            time.sleep(1)
            os.system('transset .8 -n dzentop >/dev/null')            
            os._exit(1)
        finally:
            import signal
            os.kill(pid_transset, signal.SIGTERM)
