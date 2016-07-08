-- Standard awesome library
local gears     = require("gears")

-- Theme handling library
local beautiful = require("beautiful")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/epsi/.config/awesome/themes/clone/theme.lua")
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")


-- theme.tasklist_disable_icon = true

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

theme.useless_gap_width = 16
