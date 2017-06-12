#!/usr/bin/lua
-- This is a modularized config for herbstluftwm tags in lemonbar

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
package.path   = package.path .. ';' .. dirname .. '?.lua;'
  
local helper      = require('.helper')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- process handler

function test_lemon(monitor, parameters) 
    local output = require('.output')

    local command_out  = 'lemonbar ' .. parameters .. ' -p'
    local pipe_out = assert(io.popen(command_out, 'w'))
    
    -- initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('test')

    local text = output.get_statusbar_text(monitor)
    pipe_out:write(text .. "\n")
    pipe_out:flush()
        
    pipe_out:close()
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

panel_height = 24
monitor = helper.get_monitor(arg)

-- do `man herbsluftclient`, and type \pad to search what it means
os.execute('herbstclient pad ' .. monitor .. ' ' 
    .. panel_height .. ' 0 ' .. panel_height .. ' 0')

lemon_parameters = helper.get_lemon_parameters(monitor, panel_height)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- test

test_lemon(monitor, lemon_parameters)
