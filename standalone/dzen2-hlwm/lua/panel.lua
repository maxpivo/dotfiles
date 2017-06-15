#!/usr/bin/lua
-- This is a modularized config for herbstluftwm tags in dzen2 statusbar

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
package.path   = package.path .. ';' .. dirname .. '?.lua;'

local helper      = require('.helper')
local pipehandler = require('.pipehandler')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

panel_height = 24
monitor = helper.get_monitor(arg)
dzen2_parameters = helper.get_dzen2_parameters(monitor, panel_height)

-- do `man herbsluftclient`, and type \pad to search what it means
os.execute('herbstclient pad ' .. monitor .. ' ' 
    .. panel_height .. ' 0 ' .. panel_height .. ' 0')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

-- remove all dzen2 instance
os.execute('pkill dzen2')

-- run process in the background
pipehandler.detach_dzen2(monitor, dzen2_parameters)

-- optional transparency
pipehandler.detach_transset()
