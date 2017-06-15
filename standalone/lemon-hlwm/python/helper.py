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
    
    geometry = raw.rstrip().split(' ')
    
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
# lemon Parameters

def get_lemon_parameters(monitor, panel_height):  
    # calculate geometry
    geometry = get_geometry(monitor)
    xpos, ypos, width, height = get_top_panel_geometry(
       panel_height, geometry)

    # geometry: -g widthxheight+x+y
    geom_res = str(width)+'x'+str(height)+'+'+str(xpos)+'+'+str(ypos)

    # color, with transparency    
    bgcolor = "'#aa000000'"
    fgcolor = "'#ffffff'"
    
    # XFT: require lemonbar_xft_git 
    font_takaop  = "takaopgothic-9"
    font_bottom  = "monospace-9"
    font_symbol  = "PowerlineSymbols-11"
    font_awesome = "FontAwesome-9"

    # finally
    parameters  = '  -g '+geom_res+' -u 2 ' \
                + ' -B '+bgcolor+' -F '+fgcolor \
                + ' -f '+font_takaop+' -f '+font_awesome+' -f '+font_symbol

    return parameters
