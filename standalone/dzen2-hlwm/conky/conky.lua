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

-- presetName  = 'bright-background'
-- assemblyName = 'back-arrow'

-- presetName  = 'bright-separator'
-- assemblyName = 'separator'

presetName  = 'dark-separator'
assemblyName = 'separator'

local dirname  = debug.getinfo(1).source:match("@?(.*/)")

dofile(dirname .. 'gmc.lua')
dofile(dirname .. 'presets/' .. presetName .. '.lua')
dofile(dirname .. 'helper.lua')
dofile(dirname .. 'parts.lua')
dofile(dirname .. 'assemblies/' .. assemblyName .. '.lua')

conky.text = [[\
]] .. enabled .. [[\
]]

