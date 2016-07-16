-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
local lain  = require("lain")

-- Unused Filter Tag List, Awful Monkey Patches
-- local eminent   = require("modules/eminent")
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = wibox_package

function WB.initdeco ()
    -- Spacer
    WB.spacer = wibox.widget.textbox(" ")

    -- Separators lain
    local separators = lain.util.separators
    WB.arrl_dl = separators.arrow_left("alpha", beautiful.arrow_color)
    WB.arrl_ld = separators.arrow_left(beautiful.arrow_color, "alpha")
    WB.arrl_dr = separators.arrow_right("alpha", beautiful.arrow_color)
    WB.arrl_rd = separators.arrow_right(beautiful.arrow_color, "alpha")

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

WB.setup_common_boxes = function (s)
    -- Create a promptbox for each screen
    WB.promptbox[s] = awful.widget.prompt()

    -- Create a textbox widget which will contains a short string representing the
    -- layout we're using.  We need one layoutbox per screen.
    -- WB.txtlayoutbox[s] = wibox.widget.textbox(
    --    beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(s))]
    -- )
    WB.txtlayoutbox[s] = wibox.widget.textbox(
      awful.layout.getname(awful.layout.get(s))
    )
    awful.tag.attached_connect_signal(s, "property::selected", function ()
        WB.updatelayoutbox(WB.txtlayoutbox[s], s)
    end)
    awful.tag.attached_connect_signal(s, "property::layout", function ()
        WB.updatelayoutbox(WB.txtlayoutbox[s], s)
    end)

    -- this contain error when clicked
    -- WB.txtlayoutbox[s]:buttons(awful.util.table.join(
    --        awful.button({}, 1, function() awful.layout.inc(layouts, 1) end),
    --        awful.button({}, 3, function() awful.layout.inc(layouts, -1) end),
    --        awful.button({}, 4, function() awful.layout.inc(layouts, 1) end),
    --        awful.button({}, 5, function() awful.layout.inc(layouts, -1) end)))

    -- Create an imagebox widget which will contains
    -- an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
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

function WB.add_widgets_bar (line, screen)
    local mcw = multicolor_widget_set
    local mci = multicolor_icon_set

    --  wheather

    line:add(WB.arrl_dl)
    line:add(wibox.widget.background(mci.weather, beautiful.arrow_color))
    line:add(wibox.widget.background(mcw.weather, beautiful.arrow_color))
    line:add(WB.arrl_ld)

--  volume

--  line:add(mci.mpd)     line:add(mcw.mpd)
--  line:add(WB.arrl_dl)

--  line:add(WB.arrl_ld)
--  line:add(mci.volume)     line:add(mcw.volume)
    line:add(mci.volume_dynamic)
    line:add(mcw.volume_bar_widget)

--  disk

    line:add(mci.disk)
    line:add(mcw.disk_bar_widget)

--  battery

    line:add(mci.battery)
    line:add(mcw.battery_bar_widget)

--  end arrow
    line:add(WB.arrl_dl)

    line:add(WB.arrl_ld)
    line:add(WB.spacer)

    return line
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_monitor (line, screen)
    local mcw = multicolor_widget_set
    local mci = multicolor_icon_set

    if screen == 1 then line:add(wibox.widget.systray()) end

-- time

    line:add(mci.clock)
    line:add(mcw.textclock)  -- calendar attached
--  line:add(mcw.my_textclock)

--   net

    line:add(WB.arrl_dr)
    line:add(wibox.widget.background(mci.netdown,     beautiful.arrow_color))
    line:add(wibox.widget.background(mcw.netdowninfo, beautiful.arrow_color))
    line:add(wibox.widget.background(mci.netup,       beautiful.arrow_color))
    line:add(wibox.widget.background(mcw.netupinfo,   beautiful.arrow_color))
    line:add(WB.arrl_rd)

-- mem, cpu, files system, temp, batt

    line:add(mci.mem)     line:add(mcw.mem)
    line:add(mci.cpu)     line:add(mcw.cpu)
--  line:add(mci.fs)      line:add(mcw.fs)
    line:add(mci.temp)    line:add(mcw.temp)
    line:add(mci.bat)     line:add(mcw.bat)
--  line:add(WB.arrl_dr)

    return line
end

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
