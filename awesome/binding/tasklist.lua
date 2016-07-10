-- {{{ Required libraries
local awful = require("awful")
-- }}}

local _M = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
function _M.get()
  local tasklist = {}

  tasklist.buttons =
    awful.util.table.join(
      awful.button({ }, 1, function (c)
          if c == client.focus then
              c.minimized = true
          else
              -- Without this, the following
              -- :isvisible() makes no sense
              c.minimized = false
              if not c:isvisible() then
                  local rctags = RC.tags
                  awful.tag.viewonly(c:rctags()[1])
              end
              -- This will also un-minimize
              -- the client, if needed
              client.focus = c
              c:raise()
          end
      end),
      awful.button({ }, 3, function ()
          if instance then
              instance:hide()
              instance = nil
          else
              instance = awful.menu.clients({
                  theme = { width = 250 }
              })
          end
      end),
      awful.button({ }, 4, function ()
          awful.client.focus.byidx(1)
          if client.focus then client.focus:raise() end
      end),
      awful.button({ }, 5, function ()
          awful.client.focus.byidx(-1)
          if client.focus then client.focus:raise() end
      end)
    )

  return tasklist
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
