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

local W = multicolor_widget_set     -- object name
local I = multicolor_icon_set       -- object name

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Battery from copycat-multicolor

I.bat = wibox.widget.imagebox(beautiful.widget_batt)

W.bat = lain.widgets.bat({
    settings = function()
        if bat_now.perc == "N/A" then
            perc = "AC "
        else
            perc = bat_now.perc .. "% "
        end
        widget:set_text(perc)
    end
})

-- Battery from copycat-copland

I.battery = wibox.widget.imagebox(beautiful.monitor_bat)

W.battery_bar = awful.widget.progressbar({width = 55, ticks = true, ticks_size = 6})
W.battery_bar:set_color(beautiful.fg_normal)
W.battery_bar:set_background_color(beautiful.bg_normal)

W.battery_margin = wibox.layout.margin(W.battery_bar, 2, 7)
W.battery_margin:set_top(6)
W.battery_margin:set_bottom(6)

-- Update bar, also in widgets popups
local disk_widget_settings = function()
    if bat_now.status == "N/A" then return end

    perc = tonumber(bat_now.perc)
    if perc == nil then return end

    if bat_now.status == "Charging" then
        I.battery:set_image(beautiful.monitor_ac)
        if perc >= 98 then
            W.battery_bar:set_color(green)
        elseif perc > 50 then
            W.battery_bar:set_color(beautiful.fg_normal)
        elseif perc > 15 then
            W.battery_bar:set_color(beautiful.fg_normal)
        else
            W.battery_bar:set_color(red)
        end
    else
        if perc >= 98 then
            W.battery_bar:set_color(green)
        elseif perc > 50 then
            W.battery_bar:set_color(beautiful.fg_normal)
            I.battery:set_image(beautiful.monitor_bat)
        elseif perc > 15 then
            W.battery_bar:set_color(beautiful.fg_normal)
            I.battery:set_image(beautiful.monitor_bat_low)
        else
            W.battery_bar:set_color(red)
            I.battery:set_image(beautiful.monitor_bat_no)
        end
    end
    W.battery_bar:set_value(perc / 100)
end

W.battery_widget_update = lain.widgets.bat({
    settings = disk_widget_settings
})

W.battery_bar_widget = wibox.widget.background(W.battery_margin)
W.battery_bar_widget:set_bgimage(beautiful.bar_bg_copland)
