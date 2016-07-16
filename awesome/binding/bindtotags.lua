module("binding.bindtotags", package.seeall)

-- Standard awesome library
local awful = require("awful")

local _M = {}
local modkey = RC.vars.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Key bindings

function _M.get(globalkeys)
    -- Bind all key numbers to tags.
    -- Be careful: we use keycodes to make it works on any keyboard layout.
    -- This should map on the top row of your keyboard, usually 1 to 9.
    for i = 1, 9 do
        globalkeys = awful.util.table.join(globalkeys,

            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- View tag only.
            awful.key({ modkey }, "#" .. i + 9,
                      function ()
                            local screen = mouse.screen
                            local tag = awful.tag.gettags(screen)[i]
                            if tag then
                               awful.tag.viewonly(tag)
                            end
                      end),

            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Toggle tag.
            awful.key({ modkey, "Control" }, "#" .. i + 9,
                      function ()
                          local screen = mouse.screen
                          local tag = awful.tag.gettags(screen)[i]
                          if tag then
                             awful.tag.viewtoggle(tag)
                          end
                      end),

            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Move client to tag.
            awful.key({ modkey, "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = awful.tag.gettags(client.focus.screen)[i]
                              if tag then
                                  awful.client.movetotag(tag)
                              end
                         end
                      end),

            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
            -- Toggle tag.
            awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                      function ()
                          if client.focus then
                              local tag = awful.tag.gettags(client.focus.screen)[i]
                              if tag then
                                  awful.client.toggletag(tag)
                              end
                          end
                      end))
            --  -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
    end

    return globalkeys
end
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })


-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
