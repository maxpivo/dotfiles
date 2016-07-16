-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library
local vw = require("anybox.vicious.vicious")
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = wibox_package

function WB.initdeco ()
    -- Spacer
    WB.spacer = wibox.widget.textbox(" ")
    WB.spacerline = wibox.widget.textbox(" | ")

    -- Separators png
    WB.arrl_pre = wibox.widget.imagebox()
    WB.arrl_pre:set_image(beautiful.arrl_lr_pre)
    WB.arrl_post = wibox.widget.imagebox()
    WB.arrl_post:set_image(beautiful.arrl_lr_post)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Create a wibox for each screen and add it
-- we name it one and two, because both can be switched, top or bottom
WB.one = {}
WB.two = {}

--
WB.promptbox = {}
WB.layoutbox = {}
WB.txtlayoutbox = {}

-- Writes a string representation of the current layout in a textbox widget
function WB.updatelayoutbox (layout, s)
    local screen = s or 1
    local name_l = awful.layout.getname(awful.layout.get(screen))
    local text_l = beautiful["layout_txt_" .. name_l] or ""
    layout:set_text(text_l)
end

function WB.setup_common_boxes (s)
    -- Create a promptbox for each screen
    WB.promptbox[s] = awful.widget.prompt()

    WB.txtlayoutbox[s] = wibox.widget.textbox(
        awful.layout.getname(awful.layout.get(s))
    )
    awful.tag.attached_connect_signal(s, "property::selected", function ()
        WB.updatelayoutbox(WB.txtlayoutbox[s], s)
    end)
    awful.tag.attached_connect_signal(s, "property::layout", function ()
        WB.updatelayoutbox(WB.txtlayoutbox[s], s)
    end)

    WB.layoutbox[s] = awful.widget.layoutbox(s)
    WB.layoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function () awful.layout.inc(RC.layouts, 1) end),
        awful.button({ }, 3, function () awful.layout.inc(RC.layouts, -1) end),
        awful.button({ }, 4, function () awful.layout.inc(RC.layouts, 1) end),
        awful.button({ }, 5, function () awful.layout.inc(RC.layouts, -1) end)
    ))

    -- Create a taglist widget
    -- [filter.all, filter.noempty, filter.selected], or use eminent
    WB.taglist[s] = awful.widget.taglist(
        s, awful.widget.taglist.filter.all, WB.taglist.buttons)

    -- Create a tasklist widget
    WB.tasklist[s] = awful.widget.tasklist(
        s, awful.widget.tasklist.filter.currenttags, WB.tasklist.buttons)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_main (line, s)
    line:add(RC.launcher)
    line:add(WB.taglist[s])
    line:add(WB.arrl_pre)
    line:add(WB.promptbox[s])
    line:add(WB.arrl_post)

    return line
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor (line, s)
    line:add(vw.cpu)
    line:add(vw.hddtemp)
    line:add(WB.spacerline)
    line:add(vw.mem)
    line:add(WB.spacerline)
    line:add(vw.battery)
    line:add(WB.spacerline)
    line:add(vw.net)

    return line
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_systray (line, s)
    line:add(vw.mpd)
    line:add(WB.spacerline)
    line:add(vw.date)
    line:add(WB.spacerline)

    if s == 1 then
        line:add(wibox.widget.systray())
        line:add(WB.spacerline)
    end

    line:add(WB.txtlayoutbox[s])
    line:add(WB.spacer)
    line:add(WB.layoutbox[s])

    return line
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
