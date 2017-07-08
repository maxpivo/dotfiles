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

presetName  = 'bright-background'

local dirname  = debug.getinfo(1).source:match("@?(.*/)")
dofile(dirname .. 'gmc.lua')
dofile(dirname .. 'presets/' .. presetName .. '.lua')
dofile(dirname .. 'helper.lua')
dofile(dirname .. 'parts.lua')

deco = helper.decoDoubleArrowRight

conky.text = ''
    .. parts.cpu0(colGreen300)
    .. parts.transition(deco, colGreen500, colGreen300)
    .. parts.cputemp(colGreen500)
    .. parts.transition(deco, colGreen700, colGreen500)
    .. parts.memory(colGreen700)
    .. parts.transition(deco, colWhite, colGreen700)


