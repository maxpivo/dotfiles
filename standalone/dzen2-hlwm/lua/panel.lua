#!/usr/bin/lua
-- This is a modularized config for herbstluftwm tags in dzen2 statusbar

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
package.path   = package.path .. ';' .. dirname .. '?.lua;'

local helper      = require('.helper')
local pipehandler = require('.pipehandler')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

panel_height = 24
monitor = helper.get_monitor(arg)

os.execute('pkill dzen2')
os.execute('herbstclient pad ' .. monitor .. ' ' 
    .. panel_height .. ' 0 ' .. panel_height .. ' 0')

-- run process in the background

local params_top = helper.get_params_top(monitor, panel_height)
pipehandler.detach_dzen2(monitor, params_top)

local params_bottom = helper.get_params_bottom(monitor, panel_height)
pipehandler.detach_dzen2_conky(params_bottom)

-- optional transparency
pipehandler.detach_transset()
