#!/usr/bin/lua
-- This is a modularized config for herbstluftwm tags in dzen2 statusbar

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
package.path   = package.path .. ';' .. dirname .. '?.lua;'

local helper      = require('.helper')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

panel_height = 24
monitor = helper.get_monitor(arg)

dzen2_parameters = helper.get_dzen2_parameters(monitor, panel_height)
print(dzen2_parameters)
