-- {{{ Required libraries
local awful = require("awful")
local wibox = require("wibox")
-- }}}


-- {{{ Wibox

dofile(awful.util.getdir("config") .. "/" .. "my.wibox.vicious.lua")
dofile(awful.util.getdir("config") .. "/" .. "my.wibox.multicolor.lua")
dofile(awful.util.getdir("config") .. "/" .. "my.wibox.list.lua")


-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Spacer
myspacer = wibox.widget.textbox(" ")

-- Create a wibox for each screen and add it
mywiboxtop = {}
mywiboxbottom = {}
mypromptbox = {}
mylayoutbox = {}

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the top wibox
    mywiboxtop[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the top left
    local top_left_layout = wibox.layout.fixed.horizontal()
    top_left_layout:add(mylauncher)
    top_left_layout:add(mytaglist[s])
    top_left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the top right
    local top_right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then top_right_layout:add(wibox.widget.systray()) end
    top_right_layout:add(vic_cpuwidget)
    top_right_layout:add(vic_hddwidget)
    top_right_layout:add(vic_memwidget)
    top_right_layout:add(vic_batterywidget)
--    top_right_layout:add(vic_datewidget)
    top_right_layout:add(vic_netwidget)

    top_right_layout:add(mytextclock)  
    top_right_layout:add(mylayoutbox[s])
    
    local top_mid_layout = wibox.layout.fixed.horizontal()
    top_mid_layout:add(myspacer)


    -- Now bring it all together (with the tasklist in the middle)
    local layout_top = wibox.layout.align.horizontal()
    layout_top:set_left(top_left_layout)
    layout_top:set_middle(top_mid_layout)
    layout_top:set_right(top_right_layout)

    mywiboxtop[s]:set_widget(layout_top)
    
    -- Create the bottom wibox
    mywiboxbottom[s] = awful.wibox({ position = "bottom", screen = s })    
    
    -- Widgets that are aligned to the bottom right
    local bottom_left_layout = wibox.layout.fixed.horizontal()
    if s == 1 then bottom_left_layout:add(wibox.widget.systray()) end
    bottom_left_layout:add(cpuwidget)    
    bottom_left_layout:add(netdownicon)
    bottom_left_layout:add(netdowninfo)
    bottom_left_layout:add(netupicon)
    bottom_left_layout:add(netupinfo)
    bottom_left_layout:add(volicon)
    bottom_left_layout:add(volumewidget)
    bottom_left_layout:add(memicon)
    bottom_left_layout:add(memwidget)
    bottom_left_layout:add(cpuicon)
    bottom_left_layout:add(cpuwidget)
    bottom_left_layout:add(fsicon)
    bottom_left_layout:add(fswidget)
    bottom_left_layout:add(weathericon)
    bottom_left_layout:add(myweather)
    bottom_left_layout:add(tempicon)
    bottom_left_layout:add(tempwidget)
    bottom_left_layout:add(baticon)
    bottom_left_layout:add(batwidget)
    bottom_left_layout:add(clockicon)
--    bottom_left_layout:add(mytextclock)    
    
    local bottom_mid_layout = wibox.layout.fixed.horizontal()
    bottom_mid_layout:add(myspacer)   
    

    -- Now bring it all together (with the tasklist in the middle)
    local layout_bottom = wibox.layout.align.horizontal()
    layout_bottom:set_left(bottom_left_layout)
    layout_bottom:set_middle(bottom_mid_layout)    
    layout_bottom:set_right(mytasklist[s])
   
    mywiboxbottom[s]:set_widget(layout_bottom)

end
-- }}}
