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

deco = helper.decoDoubleArrowLeft

conky.text = ''
    .. parts.transition(deco, colWhite, colRed400)
    .. parts.ssid(colRed400)
    .. parts.transition(deco, colRed400, colRed600)
    .. parts.network(colRed600)
--  .. parts.transition(deco, colRed600, colWhite)

