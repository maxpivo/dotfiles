-- Standard awesome library
local awful     = require("awful")
awful.rules     = require("awful.rules")
-- Theme handling library
local beautiful = require("beautiful")

local _M = {}

-- reading
-- https://awesomewm.org/wiki/Understanding_Rules

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get(clientkeys, clientbuttons)
  local rules = {
      -- All clients will match this rule.
      { rule = { },
        properties = {
          border_width = beautiful.border_width,
          border_color = beautiful.border_normal,
          focus = awful.client.focus.filter,
          raise = true,
          keys = clientkeys,
          buttons = clientbuttons } },
      { rule = { class = "MPlayer" },
        properties = { floating = true } },
      { rule = { class = "pinentry" },
        properties = { floating = true } },
      { rule = { class = "gimp" },
        properties = { floating = true } },
      -- Set Firefox to always map on tags number 2 of screen 1.
      -- { rule = { class = "Firefox" },
      --   properties = { tag = RC.tags[1][2] } },
  }

  return rules
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
