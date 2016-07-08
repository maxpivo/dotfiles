local awful = require("awful")
awful.util = require("awful.util")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

theme_path = awful.util.getdir("config") .. "/themes/clone/"

home          = os.getenv("HOME")
config        = awful.util.getdir("config")
themes        = config .. "/themes"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- default variables

theme = {}

dofile(theme_path .. "elements.lua")
dofile(theme_path .. "titlebar-copycat.lua")
dofile(theme_path .. "layout-default.lua")

theme.wallpaper          = theme_path .. "background.jpg"
theme.awesome_icon       = theme_path .. "launcher/logo20_kali_white.png"
theme.awesome_subicon    = theme_path .. "launcher/logo20_kali_blue.png"

-- look inside /usr/share/icons/, default: nil (don't use icon theme)
theme.icon_theme = "Tango"
theme.icon_theme_size = "32x32"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- user custom variables

dofile(theme_path .. "icons-copycat.lua")

theme.bar_bg_rainbow      = theme_path .. "bar/copycat-rainbow/widget_bg.png"
theme.bar_bg_copland      = theme_path .. "bar/copycat-copland/widget_bg.png"
theme.arrl_lr_pre         = theme_path .. "misc/copycat-dremora/arrl_lr_pre.png"
theme.arrl_lr_post        = theme_path .. "misc/copycat-dremora/arrl_lr_post.png"
theme.arrow_color         = "#c9c925"  -- "#ad3737" -- "#2980b9"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
return theme
