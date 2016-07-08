-- Standard awesome library
local gears     = require("gears")

-- Theme handling library
local beautiful = require("beautiful")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Themes define colours, icons, font and wallpapers.
beautiful.init("/home/epsi/.config/awesome/themes/clone/theme.lua")
--beautiful.init("/home/epsi/.config/awesome/themes/multicolor/theme.lua")
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")

home          = os.getenv("HOME")
--theme.wallpaper = home .. "/Pictures/wallpaper/pekarangan_1253.JPG"
--theme.wallpaper = home .. "/Pictures/winking-redhead-15558.jpg"
--theme.wallpaper = home .. "/Pictures/wallpaper/02553_lakenight_1024x768.jpg"
--theme.wallpaper = home .. "/Pictures/Free-download-rain-wallpapers-HD.jpg"
--theme.wallpaper = home .. "/Pictures/3d_objects-wallpaper-1280x800.jpg"
theme.wallpaper = home .. "/Pictures/white/white-wallpaper-21.jpg"
--theme.wallpaper = home .. "/Pictures/wally-mat.png"

-- theme.tasklist_disable_icon = true

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

theme.useless_gap_width = 16
