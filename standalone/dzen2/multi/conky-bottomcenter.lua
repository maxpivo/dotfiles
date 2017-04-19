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

home = os.getenv("HOME")
path = '/Documents/standalone/dzen2/multi/'
dofile(home .. path .. 'gmc.lua')
dofile(home .. path .. 'presets/' .. presetName .. '.lua')
dofile(home .. path .. 'helper.lua')
dofile(home .. path .. 'parts.lua')

decoleft  = helper.decoDoubleArrowLeft
decoright = helper.decoDoubleArrowRight

conky.text = ''
    .. parts.transition(decoleft, colWhite, colBlue500)
    .. parts.mpd(colBlue500)
    .. parts.transition(decoright, colWhite, colBlue500)
