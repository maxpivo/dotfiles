

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# helpers

# script arguments
def get_monitor(arguments)
  # ternary operator
  arguments.length > 0 ? arguments[0].to_i : 0
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# geometry calculation

def get_geometry(monitor)
  raw = IO.popen('herbstclient monitor_rect '+ monitor.to_s).read()

  if raw.to_s.empty?
    print('Invalid monitor ' + monitor.to_s)
    exit(1)
  end
    
  raw.split(' ')
end

def get_top_panel_geometry(height, geometry)
  # geometry has the format X Y W H
  return geometry[0].to_i, geometry[1].to_i, 
         geometry[2].to_i, height
end

def get_bottom_panel_geometry(height, geometry)
  # geometry has the format X Y W H
  return geometry[0].to_i + 0, (geometry[3].to_i - height), 
         geometry[2].to_i - 0, height
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen Parameters

def get_dzen2_parameters(monitor, panel_height)
  geometry = get_geometry(monitor)
  xpos, ypos, width, height = get_top_panel_geometry(
    panel_height, geometry)
    
  bgcolor = '#000000'
  fgcolor = '#ffffff'
  font    = '-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*'
   
  parameters  = "  -x #{xpos} -y #{ypos} -w #{width} -h #{height}" \
                " -ta l -bg '#{bgcolor}' -fg '#{fgcolor}'" \
                " -title-name dzentop" \
                " -fn '#{font}'"
end
