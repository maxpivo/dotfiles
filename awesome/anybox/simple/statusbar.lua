-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")

-- Custom Local Library: Keys and Mouse Binding
local binding = {
    taglist  = require("binding.taglist"),
    tasklist = require("binding.tasklist")
}
-- }}}

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = {}

-- Create a wibox for each screen and add it
WB.simple = {}  -- can be set top or bottom
--
WB.promptbox = {}
WB.layoutbox = {}
WB.txtlayoutbox = {}

-- Spacer
WB.spacer = wibox.widget.textbox(" ")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Writes a string representation of the current layout in a textbox widget
function WB.updatelayoutbox (layout, s)
    local screen = s or 1
    local name_l = awful.layout.getname(awful.layout.get(screen))
    local text_l = beautiful["layout_txt_" .. name_l] or ""
    layout:set_text(text_l)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

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

function WB.add_widgets_left (line, s)
    line:add(RC.launcher)
    line:add(WB.taglist[s])
    line:add(WB.promptbox[s])

    return line
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.add_widgets_right (line, s)
    line:add(WB.spacer)
    line:add(WB.txtlayoutbox[s])
    line:add(WB.spacer)

    if s == 1 then
       line:add(wibox.widget.systray())
       line:add(WB.spacer)
    end

    line:add(WB.layoutbox[s])

    return line
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.generate_wibox (s)
    -- layout: l_left, tasklis, l_right

    -- Widgets that are aligned to the top left
    local l_left = wibox.layout.fixed.horizontal()
    l_left = WB.add_widgets_left(l_left, s)

    -- Widgets that are aligned to the top right
    -- in helper.lua
    local l_right = wibox.layout.fixed.horizontal()
    l_right = WB.add_widgets_right(l_right, s)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(l_left)
    layout:set_middle(WB.tasklist[s])
    layout:set_right(l_right)

    WB.simple[s] = awful.wibox({ position = "bottom", screen = s })
    WB.simple[s]:set_widget(layout)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Main
function _M.init()
    WB.taglist  = binding.taglist()
    WB.tasklist = binding.tasklist()

    for s = 1, screen.count() do
        -- in helper.lua
        WB.setup_common_boxes(s)

        -- Create the top wibox
        WB.generate_wibox(s)
    end
  end
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.init(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
