--[[
     Original Source Modified From: github.com/copycat-killer
     https://github.com/copycat-killer/awesome-copycats/blob/master/rc.lua.copland
--]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Standard awesome library
local awful = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
local W = arrow_widget_set     -- object name
local I = arrow_icon_set       -- object name

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- ALSA volume from copycat-multicolor
I.uptime = wibox.widget.imagebox(beautiful.widget_fs)

W.uptime = wibox.widget.textbox()

W.update_uptime = function()
  local fg_color = "#000000"
  local uptime = awful.util.pread("uptime -p")
  W.uptime:set_markup(markup(fg_color, uptime))
end

W.update_uptime()
local mytimer = timer({ timeout = 30 })
mytimer:connect_signal("timeout", W.update_uptime)
mytimer:start()
