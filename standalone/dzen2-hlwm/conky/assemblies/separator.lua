-- vim: ts=4 sw=4 noet ai cindent syntax=lua

--[[
disabled = ''
    .. parts.mpd()
    .. parts.uptime()
    .. parts.battery() 
    .. parts.date()
    .. parts.time()
    .. parts.machine()
]]


enabled = ''
    .. parts.host()
    .. parts.volume()
    .. parts.memory()    
    .. parts.cpu0()
    .. parts.cputemp()
    .. parts.ssid()
    .. parts.network()
    .. helper.separator()
