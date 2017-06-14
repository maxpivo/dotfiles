#!/usr/bin/ruby
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_relative 'helper'
require_relative 'pipehandler'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

panel_height = 24
monitor = get_monitor(ARGV)

dzen2_parameters = get_dzen2_parameters(monitor, panel_height)
puts(dzen2_parameters)
