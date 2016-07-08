-- Awesome 3.5 Compatible Configuration

-- {{{ Required libraries
-- Standard awesome library
local awful     = require("awful")
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

RC = {} -- global namespace

-- os.execute("nm-applet &")
os.execute("compton &")

-- {{{ Global Variable Definitions

-- This is used later as the default terminal and editor to run.
-- RC.terminal = "xfce4-terminal"
RC.terminal = "termite"

-- Default modkey. Usually the key with a logo between Control and Alt.
RC.modkey = "Mod4"

-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

local config_path = awful.util.getdir("config") .. "/"

dofile(config_path .. "/main/" .. "error-handling.lua")
dofile(config_path .. "/main/" .. "theme.lua")
dofile(config_path .. "/main/" .. "layout.lua")
dofile(config_path .. "/main/" .. "tags.lua")
dofile(config_path .. "/main/" .. "menu.lua")
dofile(config_path .. "/binding/" .. "binding.lua")
dofile(config_path .. "/main/" .. "rules.lua")
dofile(config_path .. "/wibox/" .. "wibox.lua")
