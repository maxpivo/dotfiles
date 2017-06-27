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
local path     = dirname .. "../assets/"

dofile(path .. 'gmc.lua')
dofile(path .. 'helper.lua')
dofile(path .. 'parts.lua')

-- shortcut
local _h = helper
lf = helper.lemonForeground
lb = helper.lemonBackground
la = helper.lemonBackgroundAlpha
lu = helper.lemonUnderline
lr = helper.lemonReset

conky.text = [[\
%{l}\
]] .. lr() .. lf(colRed500) .. [[  \
]] .. parts.uptime    () .. [[\
%{c}\
]] .. lr() .. [[\
]] .. parts.battery   () 
   .. parts.cpu0      ()
   .. parts.cputemp   ()
   .. parts.memory    ()
   .. parts.volume    ()
   .. lr() .. [[\
%{r}\
]] .. lr() .. [[\
]] .. parts.host      () .. [[\
]] .. lf(colRed500) .. [[  \
]]
