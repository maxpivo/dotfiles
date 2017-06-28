#!/usr/bin/ruby
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_relative 'helper'
require_relative 'pipehandler'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

panel_height = 24
monitor = get_monitor(ARGV)

kill_zombie()
system("herbstclient pad #{monitor} #{panel_height} 0 #{panel_height} 0")

# run process in the background

params_top = get_params_top(monitor, panel_height)
detach_lemon(monitor, params_top)

params_bottom = get_params_bottom(monitor, panel_height)
detach_lemon_conky(params_bottom)
