-- vim: ts=4 sw=4 noet ai cindent syntax=lua

--[[
Conky, a system monitor, based on torsmo
]]

conky.config = {
    out_to_x = false,
    out_to_console = true,
    short_units = true,
    update_interval = 1
}

-- load subroutine
home = os.getenv("HOME")
path = '/Documents/standalone/cli/conky/'
dofile(home .. path .. 'ansi.lua')
dofile(home .. path .. 'helper.lua')
dofile(home .. path .. 'parts.lua')

-- shortcut
local _h = helper

--[[
-- if you care about performance, comment-out this variable.
disabled = ''
    .. parts.title     
    .. parts.newline    
    .. parts.newline
    .. parts.date
    .. parts.time    
    .. parts.newline 
    .. parts.mem    
]]

enabled = ''
    .. parts.newline 
    .. parts.newline

    .. parts.uptime
    .. parts.newline
    .. parts.host
    .. parts.machine    
    .. parts.newline
    
    .. parts.volume
    .. parts.newline
    .. parts.mpd
    .. parts.newline
    .. parts.newline 
       
    .. parts.datetime   
    .. parts.newline 
    .. parts.newline

    .. parts.cpu0        
    .. parts.newline
    .. parts.cputemp
    .. parts.newline
    .. parts.memory
    .. parts.newline
    .. parts.battery    
      
    .. parts.newline
    .. parts.newline
    .. parts.ssid
    .. parts.network
    .. parts.newline 
    .. parts.newline
    
conky.text = _h.gototopleft() .. [[\
]] .. enabled .. [[
]]
