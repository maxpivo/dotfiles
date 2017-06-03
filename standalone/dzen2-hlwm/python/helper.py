import os

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# helpers

# script arguments
def get_monitor(arguments):
    # ternary operator
    monitor = int(arguments[1]) if (len(arguments) > 1) else 0

    return monitor

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# geometry calculation

def get_geometry(monitor):
    raw = os.popen('herbstclient monitor_rect '+ str(monitor)).read()

    if not raw: 
        print('Invalid monitor ' + str(monitor))
        exit(1)
    
    geometry = raw.split(' ')
    
    return geometry

def get_top_panel_geometry(height, geometry):
    # geometry has the format X Y W H
    return (geometry[0], geometry[1], geometry[2], height)

def get_bottom_panel_geometry(height, geometry):
    # geometry has the format X Y W H
    return (geometry[0], geometry[3]-height, geometry[2], height)

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen Parameters

def get_dzen2_parameters(monitor, panel_height):  
    geometry = get_geometry(monitor)
    xpos, ypos, width, height = get_top_panel_geometry(
       panel_height, geometry); 
    
    bgcolor = '#000000'
    fgcolor = '#ffffff'
    font    = '-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*'

    parameters  = '  -x '+str(xpos)+' -y '+str(ypos)
    parameters += ' -w '+str(width)+' -h '+ str(height)
    parameters += " -fn '"+font+"'"
    parameters += " -ta l -bg '"+bgcolor+"' -fg '"+fgcolor+"'"
    parameters += ' -title-name dzentop'

    return parameters
