-- vim: ts=4 sw=4 noet ai cindent syntax=lua

-- for use white bright dzen2 panel

deco = helper.decoDoubleArrowLeft

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
    .. helper.separator()
]]


enabled = ''
    .. parts.transition(deco, colWhite, colGreen400)
    .. parts.host(colGreen400)
    .. parts.transition(deco, colGreen400, colGreen500)
    .. parts.volume(colGreen500)
    .. parts.transition(deco, colGreen500, colGreen600)
    .. parts.cpu0(colGreen600)
    .. parts.transition(deco, colGreen600, colBlue500)
    .. parts.ssid(colBlue500)
    .. parts.transition(deco, colBlue500, colBlue600)
    .. parts.network(colBlue600)
    .. parts.transition(deco, colBlue600, colWhite)
