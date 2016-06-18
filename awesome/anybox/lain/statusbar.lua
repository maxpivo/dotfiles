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
require("anybox.lain.lain")

-- }}}

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = {}
wibox_package = WB               -- global object name

-- split module, to make each file shorter,
-- all must have same package name
local config_path = awful.util.getdir("config") .. "/anybox/"
dofile(config_path .. "helper.lua")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

WB.generate_wibox_top = function (s)

  -- Widgets that are aligned to the top left
  local top_left_layout = wibox.layout.fixed.horizontal()
  top_left_layout:add(RC.launcher)
  top_left_layout:add(WB.taglist[s])
  top_left_layout:add(WB.arrl_pre)
  top_left_layout:add(WB.promptbox[s])
  top_left_layout:add(WB.arrl_post)

  -- Widgets that are aligned to the top right
  -- in helper.lua
  --local top_right_layout = WB.vicious_widgets(s)
  local top_right_layout = WB.multicolor_widgets_top(s)

  if screen == 1 then top_right_layout:add(wibox.widget.systray()) end
  top_right_layout:add(WB.txtlayoutbox[s])
  top_right_layout:add(WB.layoutbox[s])

  local top_mid_layout = wibox.layout.fixed.horizontal()
  top_mid_layout:add(WB.spacer)

  -- Now bring it all together (with the tasklist in the middle)
  local layout_top = wibox.layout.align.horizontal()
  layout_top:set_left(top_left_layout)
  layout_top:set_middle(top_mid_layout)
  layout_top:set_right(top_right_layout)

  WB.top[s] = awful.wibox({ position = "top", screen = s }) -- , height = "28"
  WB.top[s]:set_widget(layout_top)
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

WB.generate_wibox_bottom = function (s)

  -- Widgets that are aligned to the bottom left
  -- in helper.lua
  local bottom_left_layout = WB.multicolor_widgets_bottom(s)

  local bottom_mid_layout = wibox.layout.fixed.horizontal()
  bottom_mid_layout:add(WB.spacer)

  -- Now bring it all together (with the tasklist in the middle)
  local layout_bottom = wibox.layout.align.horizontal()
  layout_bottom:set_left(bottom_left_layout)
  layout_bottom:set_middle(bottom_mid_layout)
  layout_bottom:set_right(WB.tasklist[s])

  WB.bottom[s] = awful.wibox({ position = "bottom", screen = s })
  WB.bottom[s]:set_widget(layout_bottom)
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
    WB.generate_wibox_top(s)

    -- Create the bottom wibox
    WB.generate_wibox_bottom(s)
  end
end
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.init(...) end })
