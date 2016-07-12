-- Standard awesome library
local gears     = require("gears")
local awful = require("awful")

-- Theme handling library
local beautiful = require("beautiful")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
home = os.getenv("HOME")

-- Themes define colours, icons, font and wallpapers.
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(home .. "/.config/awesome/themes/clone/theme.lua")

if (require("main.user-variables").wallpaper) then
  local wallpaper = home .. require("main.user-variables").wallpaper
  if awful.util.file_readable(wallpaper) then theme.wallpaper = wallpaper end
end

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

-- https://awesomewm.org/wiki/Remove_icons
-- theme.tasklist_disable_icon = true

theme.useless_gap_width = 16
