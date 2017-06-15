#!/usr/bin/lua
-- This is a modularized config for herbstluftwm tags in lemonbar

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
package.path   = package.path .. ';' .. dirname .. '?.lua;'
  
local helper      = require('.helper')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

local panel_height = 24
local monitor = helper.get_monitor(arg)

local lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)
print(lemon_parameters)
