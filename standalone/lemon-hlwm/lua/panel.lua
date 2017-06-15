#!/usr/bin/lua
-- This is a modularized config for herbstluftwm tags in lemonbar

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
package.path   = package.path .. ';' .. dirname .. '?.lua;'
  
local helper      = require('.helper')
local pipehandler = require('.pipehandler')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

local panel_height = 24
local monitor = helper.get_monitor(arg)

-- do `man herbsluftclient`, and type \pad to search what it means
os.execute('herbstclient pad ' .. monitor .. ' ' 
    .. panel_height .. ' 0 ' .. panel_height .. ' 0')

local lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

-- remove all lemonbar instance
os.execute('pkill lemonbar')

-- run process in the background
pipehandler.detach_lemon(monitor, lemon_parameters)
