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

function WB.initdeco()

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
WB.top = {}
WB.bottom = {}
WB.promptbox = {}
WB.layoutbox = {}
WB.txtlayoutbox = {}

-- Writes a string representation of the current layout in a textbox widget
function WB.updatelayoutbox(layout, s)
    local screen = s or 1
    local txt_l = beautiful["layout_txt_" .. awful.layout.getname(awful.layout.get(screen))] or ""
    layout:set_text(txt_l)
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
  WB.layoutbox[s]:buttons(
    awful.util.table.join(
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

WB.vicious_widgets = function (screen)
  local vic = wibox.layout.fixed.horizontal()
  local vw = require("anybox.vicious")

  if screen == 1 then vic:add(wibox.widget.systray()) end

  vic:add(vw.cpu)
  vic:add(vw.hddtemp)
  vic:add(vw.mem)
  vic:add(vw.battery)
  vic:add(vw.net)
--vic:add(vw.mpd)
  vic:add(vw.date)
--vic:add(WB.arrl_pre)
--vic:add(WB.arrl_post)

  return vic
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

WB.multicolor_widgets_top = function (screen)
  local mc = wibox.layout.fixed.horizontal()
  local mcw = multicolor_widget_set
  local mci = multicolor_icon_set

  if screen == 1 then mc:add(wibox.widget.systray()) end

  --  wheather

  mc:add(WB.arrl_dl)
  mc:add(wibox.widget.background(mci.weather, beautiful.arrow_color))
  mc:add(wibox.widget.background(mcw.weather, beautiful.arrow_color))
  mc:add(WB.arrl_ld)


-- volume

--  mc:add(mci.mpd)     mc:add(mcw.mpd)
--  mc:add(WB.arrl_dl)

--  mc:add(WB.arrl_ld)
--mc:add(mci.volume)     mc:add(mcw.volume)
  mc:add(mci.volume_dynamic)
  mc:add(mcw.volume_bar_widget)

-- disk

  mc:add(mci.disk)
  mc:add(mcw.disk_bar_widget)

-- battery

  mc:add(mci.battery)
  mc:add(mcw.battery_bar_widget)

-- end
  mc:add(WB.arrl_dl)

  mc:add(WB.arrl_ld)
  mc:add(WB.spacer)

  return mc
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

WB.multicolor_widgets_bottom = function (screen)
  local mc = wibox.layout.fixed.horizontal()
  local mcw = multicolor_widget_set
  local mci = multicolor_icon_set

  if screen == 1 then mc:add(wibox.widget.systray()) end

-- time

  mc:add(mci.clock)
  mc:add(mcw.textclock)  -- calendar attached
--mc:add(mcw.my_textclock)

-- net

  mc:add(WB.arrl_dr)
  mc:add(wibox.widget.background(mci.netdown,     beautiful.arrow_color))
  mc:add(wibox.widget.background(mcw.netdowninfo, beautiful.arrow_color))
  mc:add(wibox.widget.background(mci.netup,       beautiful.arrow_color))
  mc:add(wibox.widget.background(mcw.netupinfo,   beautiful.arrow_color))
  mc:add(WB.arrl_rd)

-- mem, cpu, files system, temp, batt

  mc:add(mci.mem)     mc:add(mcw.mem)
  mc:add(mci.cpu)     mc:add(mcw.cpu)
--mc:add(mci.fs)      mc:add(mcw.fs)
  mc:add(mci.temp)    mc:add(mcw.temp)
  mc:add(mci.bat)     mc:add(mcw.bat)
--mc:add(WB.arrl_dr)

  return mc
end
