#!/usr/bin/lua
-- This is a modularized config for herbstluftwm tags in lemonbar

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
package.path   = package.path .. ';' .. dirname .. '?.lua;'
  
local helper      = require('.helper')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

panel_height = 24
monitor = helper.get_monitor(arg)

lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)
print(lemon_parameters)
