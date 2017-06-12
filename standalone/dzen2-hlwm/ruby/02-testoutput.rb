#!/usr/bin/ruby
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_relative 'helper'
require_relative 'pipehandler'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# process handler

def test_dzen2(monitor, parameters)
  require_relative 'output'

  command_out  = 'dzen2 ' + parameters + ' -p'
  IO.popen(command_out, "w") do |f| 
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

panel_height = 24
monitor = get_monitor(ARGV)

# do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad #{monitor} #{panel_height} 0 #{panel_height} 0")

dzen2_parameters = get_dzen2_parameters(monitor, panel_height)

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

# run process
test_dzen2(monitor, dzen2_parameters)
