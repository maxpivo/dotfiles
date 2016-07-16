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

-- Custom Local Library
require("anybox.arrow.lain")

-- }}}

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = {}
wibox_package = WB               -- global object name

-- split module, to make each file shorter,
-- all must have same package name
local config_path = awful.util.getdir("config") .. "/anybox/arrow/"
dofile(config_path .. "helper.lua")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.generate_wibox_one (s)
    -- layout: l_left, l_mid, l_right

    -- Widgets that are aligned to the top left
    local l_left = wibox.layout.fixed.horizontal()
    l_left = WB.add_widgets_main(l_left, s)

    -- Widgets that are aligned to the top right
    -- in helper.lua
    local l_right = wibox.layout.fixed.horizontal()
    l_right = WB.add_widgets_bar(l_right, s)
    l_right:add(WB.txtlayoutbox[s])
    l_right:add(WB.layoutbox[s])

    local l_mid = wibox.layout.fixed.horizontal()
    l_mid:add(WB.spacer)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(l_left)
    layout:set_middle(l_mid)
    layout:set_right(l_right)

    WB.one[s] = awful.wibox({ position = "bottom", screen = s }) -- , height = "28"
    WB.one[s]:set_widget(layout)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function WB.generate_wibox_two (s)
    -- layout: l_left, tasklist, l_right

    -- Widgets that are aligned to the bottom left
    -- in helper.lua
    local l_left = wibox.layout.fixed.horizontal()
    l_left = WB.add_widgets_monitor(l_left, s)

    local l_right = wibox.layout.fixed.horizontal()
    l_right = WB.add_widgets_custom(l_right, s)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(l_left)
    layout:set_middle(WB.tasklist[s])
    layout:set_right(l_right)

    WB.two[s] = awful.wibox({ position = "top", screen = s })
    WB.two[s]:set_widget(layout)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Main
function _M.init()
    WB.taglist  = binding.taglist()
    WB.tasklist = binding.tasklist()

    WB.initdeco()

    for s = 1, screen.count() do
        -- in helper.lua
        WB.setup_common_boxes(s)

        -- Create the top wibox
        WB.generate_wibox_one(s)

        -- Create the bottom wibox
        WB.generate_wibox_two(s)
    end
end
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.init(...) end })

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
