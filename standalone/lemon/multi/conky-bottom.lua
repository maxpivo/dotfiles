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

home = os.getenv("HOME")
path = '/Documents/standalone/lemon/multi/'
dofile(home .. path .. 'gmc.lua')
dofile(home .. path .. 'helper.lua')
dofile(home .. path .. 'parts.lua')

-- shortcut
local _h = helper
lf = helper.lemonForeground
lb = helper.lemonBackground
la = helper.lemonBackgroundAlpha
lu = helper.lemonUnderline
lr = helper.lemonReset

left = lr()
    .. parts.cpu0      (colBlue500)
    .. parts.separator (colBlue500, colGreen500, colBlue300)
    .. parts.cputemp   (colGreen500)
    .. parts.separator (colGreen500, colBlue400, colGreen300)
    .. parts.memory    (colBlue400)
    .. lf(colBlue400) .. ''
    
right = lr()
    .. lf(colBlue500) .. ''
    .. parts.ssid      (colBlue500)
    .. parts.separator (colBlue500, colGreen500, colBlue700)    
    .. parts.network   (colGreen500)
    
center = lr()
    .. lf(colBlue500) .. ''
    .. parts.volume    (colBlue500)
    .. parts.separator (colBlue500, colGreen500, colBlue700)
    .. parts.mpd       (colGreen500)
    .. lf(colGreen500) .. ''

conky.text = [[\
%{l}\
]] .. left .. [[\
%{r}\
]] .. right .. [[\
%{c}\
]] .. center
