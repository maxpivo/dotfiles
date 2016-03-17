-- {{{ Required libraries
local awful = require("awful")
local wibox = require("wibox")
local vicious = require("vicious")
-- }}}

hlcolor = "#d7e0ea"

--  Network usage widget
-- Initialize widget, use widget({ type = "textbox" }) for awesome < 3.5
vic_netwidget = wibox.widget.textbox()
-- Register widget
vicious.register(vic_netwidget, vicious.widgets.net, 
	'${wlp0s3f3u2 down_kb}${wlp0s3f3u2 up_kb} | ', 3)

vic_datewidget = wibox.widget.textbox()
vicious.register(vic_datewidget, vicious.widgets.date, "%b %d, %R")

vic_batterywidget = wibox.widget.textbox()
vicious.register(vic_batterywidget, vicious.widgets.bat, 
	"Bat: <span color='" .. hlcolor .. "'>$1$2</span> | ",67,"BAT0")

vic_memwidget = wibox.widget.textbox()
vicious.cache(vicious.widgets.mem)
vicious.register(vic_memwidget, vicious.widgets.mem, 
	"Mem: <span color='" .. hlcolor .. "'>$1%</span> ($2MB/$3MB) | ", 13)


vic_hddwidget = wibox.widget.textbox()
vicious.register(vic_hddwidget, vicious.widgets.hddtemp, 
	"HDD: <span color='" .. hlcolor .. "'>${/dev/sda}°С</span> | ",41,"7634")

vic_mpdwidget = wibox.widget.textbox()
vicious.register(vic_mpdwidget, vicious.widgets.mpd,
    function (vic_mpdwidget, args)
        if args["{state}"] == "Stop" then 
            return " - "
        else 
            return args["{Artist}"]..' - '.. args["{Title}"]
        end
    end, 10)
    
vic_cpuwidget = awful.widget.graph()
vic_cpuwidget:set_width(50)
vic_cpuwidget:set_background_color("#494B4F")
vic_cpuwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 50, 0 }, stops = { { 0, "#FF5656" }, { 0.5, "#88A175" }, { 1, "#AECF96" }}})
vicious.cache(vicious.widgets.cpu)
vicious.register(vic_cpuwidget, vicious.widgets.cpu, "$1", 3)    
