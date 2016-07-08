-- Standard Awesome library
local awful = require("awful")

-- Custom Library
require("main/titlebar")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local modkey = RC.modkey

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end),

    --  https://monkeyprogramming.wordpress.com/2013/09/02/how-to-toggle-titlebar-visibility-on-awesome-3-5/
    awful.key( { modkey, "Shift" }, "t",
        function (c)
            -- toggle titlebar
            if (c:titlebar_top():geometry()['height'] > 0) then
                awful.titlebar(c, {size = 0})
            else
                awful.titlebar(c):set_widget(titlebar_layout(c))
            end
        end)
)
