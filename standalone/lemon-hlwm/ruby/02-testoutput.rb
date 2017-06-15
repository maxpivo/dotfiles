#!/usr/bin/ruby
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_relative 'helper'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# process handler

def test_lemon(monitor, parameters)
  require_relative 'output'

  command_out  = 'lemonbar ' + parameters + ' -p'
  IO.popen(command_out, 'w') do |f|   
    # initialize statusbar
    set_tag_value(monitor)
    set_windowtitle('test')
      
    text = get_statusbar_text(monitor)
    f.puts(text)
        
    f.close()    
  end
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

local panel_height = 24
local monitor = get_monitor(ARGV)
local lemon_parameters = get_lemon_parameters(monitor, panel_height)

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

# do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad #{monitor} #{panel_height} 0 #{panel_height} 0")

# run process
test_lemon(monitor, lemon_parameters)
