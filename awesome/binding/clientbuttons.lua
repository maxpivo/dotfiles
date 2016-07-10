module("binding.clientbuttons", package.seeall)

-- Standard awesome library
local awful = require("awful")

local _M = {}
local modkey = require("main.user-variables").modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()
  local clientbuttons = awful.util.table.join(
      awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
      awful.button({ modkey }, 1, awful.mouse.client.move),
      awful.button({ modkey }, 3, awful.mouse.client.resize))

  return clientbuttons
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
