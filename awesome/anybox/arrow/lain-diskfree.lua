--[[
     Original Source Modified From: github.com/copycat-killer
     https://github.com/copycat-killer/awesome-copycats/blob/master/rc.lua.copland
--]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
local lain = require("lain")

local W = arrow_widget_set     -- object name
local I = arrow_icon_set       -- object name

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- / fs

I.fs = wibox.widget.imagebox(beautiful.widget_fs)

--[[
-- Can't create more than one fs widget
W.fs = lain.widgets.fs({
    settings  = function()
        widget:set_markup(markup("#80d9d8", fs_now.used .. "% "))
    end
})
]]

-- /home fs
I.disk = wibox.widget.imagebox(beautiful.monitor_disk)

W.disk_bar = awful.widget.progressbar({width = 55, ticks = true, ticks_size = 6})
W.disk_bar:set_color(beautiful.fg_normal)
W.disk_bar:set_background_color(beautiful.bg_normal)

W.disk_margin = wibox.layout.margin(W.disk_bar, 2, 7)
W.disk_margin:set_top(6)
W.disk_margin:set_bottom(9)

-- Update bar, also in widgets popups
local disk_widget_settings = function()
    if fs_now.used < 90 then
        W.disk_bar:set_color(beautiful.fg_normal)
    else
        W.disk_bar:set_color("#EB8F8F")
    end
    W.disk_bar:set_value(fs_now.used / 100)
end

W.disk_widget_update = lain.widgets.fs({
    partition = "/",
    settings  = disk_widget_settings
})

W.disk_bar_widget = wibox.widget.background(W.disk_margin)
W.disk_bar_widget:set_bgimage(beautiful.bar_bg_copland)
