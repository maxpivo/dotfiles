-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local WB = {}
wibox_package = WB               -- package name

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local config_path = awful.util.getdir("config") .. "/wibox/"

dofile(config_path .. "vicious.lua")
dofile(config_path .. "lain-multicolor.lua")
dofile(config_path .. "list-tag.lua")
dofile(config_path .. "list-task.lua")
dofile(config_path .. "helper.lua")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

WB.generate_wibox_top = function (s)

  -- Widgets that are aligned to the top left
  local top_left_layout = wibox.layout.fixed.horizontal()
  top_left_layout:add(menu_object.launcher)
  top_left_layout:add(WB.taglist[s])
  top_left_layout:add(WB.arrl_pre)
  top_left_layout:add(WB.promptbox[s])
  top_left_layout:add(WB.arrl_post)

  -- Widgets that are aligned to the top right
  -- in helper.lua
  --local top_right_layout = WB.vicious_widgets(s)
  local top_right_layout = WB.multicolor_widgets_top(s)

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
for s = 1, screen.count() do
  -- in helper.lua
  WB.setup_common_boxes(s)

  -- Create the top wibox
  WB.generate_wibox_top(s)

  -- Create the bottom wibox
  WB.generate_wibox_bottom(s)
end
-- }}}
