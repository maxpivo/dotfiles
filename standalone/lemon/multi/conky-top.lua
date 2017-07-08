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

--[[
Prepare
]]

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
dofile(dirname .. 'gmc.lua')
dofile(dirname .. 'helper.lua')
dofile(dirname .. 'parts.lua')

-- shortcut
local _h = helper
lf = helper.lemonForeground
lb = helper.lemonBackground
la = helper.lemonBackgroundAlpha
lu = helper.lemonUnderline
lr = helper.lemonReset

left = lr()
    .. parts.host      (colBlue500)
    .. parts.separator (colBlue500, colGreen500, colBlue700)    
    .. parts.machine   (colGreen500)
    .. lf(colGreen500) .. ''
    
right = lr()
    .. lf(colBlue500) .. ''
    .. parts.date      (colBlue500)
    .. parts.separator (colBlue500, colGreen500, colBlue700)    
    .. parts.time      (colGreen500)
    
center = lr()
    .. lf(colBlue500) .. ''
    .. parts.uptime      (colBlue500)
    .. lf(colBlue500) .. ''

conky.text = [[\
%{l}\
]] .. left .. [[\
%{r}\
]] .. right .. [[\
%{c}\
]] .. center
