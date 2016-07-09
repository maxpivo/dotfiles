--[[
     Vicious Sample Widget Source Taken From:  
     https://awesome.naquadah.org/wiki/Vicious#Example_widgets
--]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --


-- {{{ Required libraries
local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local W = {}
vicious_widget_set = W           -- package name

local hlcolor = "#d7e0ea"

local wlandev = 'wlp0s3f3u2'

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

--  Network usage widget
-- Initialize widget, use widget({ type = "textbox" }) for awesome < 3.5
W.net = wibox.widget.textbox()
-- Register widget
vicious.register(W.net, vicious.widgets.net,
	'${'.. wlandev .. ' down_kb} ${'.. wlandev .. ' up_kb} | ', 3)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.date = wibox.widget.textbox()
vicious.register(W.date, vicious.widgets.date, "%b %d, %R  ")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.battery = wibox.widget.textbox()
vicious.register(W.battery, vicious.widgets.bat,
	"Bat: <span color='" .. hlcolor .. "'>$1$2</span> | ",67,"BAT0")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.mem = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(W.mem, vicious.widgets.mem,
	"Mem: <span color='" .. hlcolor .. "'>$1%</span> ($2MB/$3MB) | ", 13)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- setuid in debian
-- sudo dpkg-reconfigure hddtemp

W.hddtemp = wibox.widget.textbox()
vicious.register(W.hddtemp, vicious.widgets.hddtemp,
	" HDD: <span color='" .. hlcolor .. "'>${/dev/sda}°С</span> | ",41,"7634")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.mpd = wibox.widget.textbox()
wmpd = W.mpd
vicious.register(W.mpd, vicious.widgets.mpd,
    function (wmpd, args)
        if args["{state}"] == "Stop" then
            return " - "
        else
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

W.cpu = awful.widget.graph()
W.cpu:set_width(50)
W.cpu:set_background_color("#494B4F")
W.cpu:set_color({
  type = "linear",
  from = { 0, 0 },
	to = { 50, 0 },
	stops = { { 0, "#FF5656" }, { 0.5, "#88A175" }, { 1, "#AECF96" }}
})
vicious.cache(vicious.widgets.cpu)
vicious.register(W.cpu, vicious.widgets.cpu, "$1", 3)
