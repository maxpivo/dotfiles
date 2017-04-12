-- vim: ts=4 sw=4 noet ai cindent syntax=lua

--[[
disabled = ''
    .. parts.mpd()
    .. parts.uptime()
    .. parts.memory()
    .. parts.battery() 
    .. parts.date()
    .. parts.time()
    .. parts.cputemp()
    .. parts.machine()
]]


enabled = ''
    .. parts.host()
    .. parts.volume()
    .. parts.cpu0()
    .. parts.ssid()
    .. parts.network()
    .. helper.separator()
