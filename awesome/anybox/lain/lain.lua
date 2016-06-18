--[[
     Original Source Modified From: github.com/copycat-killer
     https://github.com/copycat-killer/awesome-copycats/blob/master/rc.lua.multicolor
--]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
local lain = require("lain")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local W = {}
multicolor_widget_set = W           -- object name

local I = {}
multicolor_icon_set = I             -- object name

-- split module, to make each file shorter,
-- all must have same package name

-- global for all splited
markup      = lain.util.markup

-- progress bar related widgets -- after global markup
local config_path = awful.util.getdir("config") .. "/anybox/"
dofile(config_path .. "lain-diskfree.lua")
dofile(config_path .. "lain-battery.lua")
dofile(config_path .. "lain-sound.lua")



-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Textclock
I.clock = wibox.widget.imagebox(beautiful.widget_clock)

W.my_textclock = awful.widget.textclock(
    markup("#7788af", "%A %d %B ")
      .. markup("#343639", ">")
      .. markup("#de5e1e", " %H:%M "))

W.textclock = lain.widgets.abase({
    timeout  = 60,
    cmd      = "date +'%A %d %B %R'",
    settings = function()
        local t_output = ""
        local o_it = string.gmatch(output, "%S+")

        for i=1,3 do t_output = t_output .. " " .. o_it(i) end

        widget:set_markup(markup("#7788af", t_output)
          .. markup("#343639", " > ")
          .. markup("#de5e1e", o_it(1)) .. " ")
    end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Calendar
lain.widgets.calendar:attach(W.textclock,
  { font_size = 10,fg = "#FFFFFF", position = "bottom_left" })

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Weather
I.weather = wibox.widget.imagebox(beautiful.widget_weather)

W.weather = lain.widgets.weather({
    city_id = 1642911, -- http://openweathermap.org/city/1642911
    settings = function()
        descr = weather_now["weather"][1]["description"]:lower()
        units = math.floor(weather_now["main"]["temp"])
        local fg_color = "#000000" -- "#eca4c4"
        widget:set_markup(markup(fg_color, descr .. " @ " .. units .. "°C "))
    end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--[[ Mail IMAP check
-- commented because it needs to be set before use
I.mail = wibox.widget.imagebox()
I.mail:buttons(awful.util.table.join(
  awful.button({ }, 1, function () awful.util.spawn(mail) end))
)

W.mail = lain.widgets.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    settings = function()
        if mailcount > 0 then
            mailicon:set_image(beautiful.widget_mail)
            widget:set_markup(markup("#cccccc", mailcount .. " "))
        else
            widget:set_text("")
            mailicon:set_image(nil)
        end
    end
})
]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- CPU
I.cpu = wibox.widget.imagebox()
I.cpu:set_image(beautiful.widget_cpu)

W.cpu = lain.widgets.cpu({
    settings = function()
        widget:set_markup(markup("#e33a6e", cpu_now.usage .. "% "))
    end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Coretemp
I.temp = wibox.widget.imagebox(beautiful.widget_temp)

W.temp = lain.widgets.temp({
    settings = function()
        widget:set_markup(markup("#f1af5f", coretemp_now .. "°C "))
    end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Net
I.netdown = wibox.widget.imagebox(beautiful.widget_netdown)
--netdownicon.align = "middle"

W.netdowninfo = wibox.widget.textbox()

I.netup = wibox.widget.imagebox(beautiful.widget_netup)
--netupicon.align = "middle"

W.netupinfo = lain.widgets.net({
    settings = function()
--        if iface ~= "network off" and
--           string.match(myweather._layout.text, "N/A")
--        then
--            myweather.update()
--        end

        local fg_color_up   = "#000000" -- "#e54c62"
        local fg_color_down = "#000000" -- "#87af5f"
        widget:set_markup(markup(fg_color_up, net_now.sent .. " "))
        W.netdowninfo:set_markup(markup(fg_color_down, net_now.received .. " "))
    end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- MEM
I.mem = wibox.widget.imagebox(beautiful.widget_mem)
W.mem = lain.widgets.mem({
    settings = function()
        widget:set_markup(markup("#e0da37", mem_now.used .. "M "))
    end
})
