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
    return (int(geometry[0]), int(geometry[1]),
            int(geometry[2]), height)

def get_bottom_panel_geometry(height, geometry):
    # geometry has the format X Y W H
    return (int(geometry[0]) + 0, int(geometry[3]) - height, 
            int(geometry[2]) - 0, height )

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen Parameters

def get_params_top(monitor, panel_height):  
    geometry = get_geometry(monitor)
    xpos, ypos, width, height = get_top_panel_geometry(
       panel_height, geometry)
    
    bgcolor = '#000000'
    fgcolor = '#ffffff'
    font    = '-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*'

    parameters  = '  -x '+str(xpos)+' -y '+str(ypos) \
                + ' -w '+str(width)+' -h '+str(height) \
                +  " -ta l -bg '"+bgcolor+"' -fg '"+fgcolor+"'" \
                +  ' -title-name dzentop' \
                +  " -fn '"+font+"'"

    return parameters

def get_params_bottom(monitor, panel_height):  
    geometry = get_geometry(monitor)
    xpos, ypos, width, height = get_bottom_panel_geometry(
       panel_height, geometry)
    
    bgcolor = '#000000'
    fgcolor = '#ffffff'
    font    = '-*-fixed-medium-*-*-*-11-*-*-*-*-*-*-*'

    parameters  = '  -x '+str(xpos)+' -y '+str(ypos) \
                + ' -w '+str(width)+' -h '+str(height) \
                +  " -ta l -bg '"+bgcolor+"' -fg '"+fgcolor+"'" \
                +  ' -title-name dzenbottom' \
                +  " -fn '"+font+"'"

    return parameters

def get_dzen2_parameters(monitor, panel_height):
    return get_params_top(monitor, panel_height)
