-- Standard awesome library
local awful = require("awful")
-- Theme handling library
local beautiful = require("beautiful")
-- Required librariy
local menubar = require("menubar")
local menugen = require("modules/menugen")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
local M = {}
menu_object = M                  -- global namespace

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Variable definitions
-- This is used later as the default terminal and editor to run.
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = RC.terminal .. " -e " .. editor
-- }}}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Menu
-- Create a laucher widget and a main menu
M.awesome = {
   { "manual", RC.terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "Terminal", RC.terminal },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

M.favorite = {
	{ "firefox", "firefox", awful.util.getdir("config") .. "/firefox.png" },
	{ "chromium", "chromium" },
	{ "&firefox", "firefox" },
	{ "&thunderbird", "thunderbird" },
	{ "deluge", "deluge" },
	{ "geany", "geany" },
	{ "atom", "atom" },
	{ "thunar", "thunar" },
	{ "gimp", "gimp" },
	{ "inkscape", "inkscape" },
	{ "screenshooter", "xfce4-screenshooter" },
}

M.network_main = {
    { "wicd-curses", "wicd-curses" },
    { "wicd-gtk", "wicd-gtk" }
}

-- dofile(awful.util.getdir("config") .. "/rc/" .. "menu.blackarch.lua")


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
--[[
-- Main Menu
-- menu_items = {
--	{ "awesome", M.awesome, beautiful.awesome_subicon },
--	{ "open terminal", terminal },
--	{ "blackarch", M.blackarch },
--  { "network", M.network_main },
--	{ "favorite", M.favorite }
--	}

-- Generated Menu
-- gen_items = menugen.build_menu()

-- Merge Each Submenu
-- for item in gen_items do
--  table.insert(menu_items, item)
-- end
]]

menu_items = require("menugen").build_menu()
table.insert(menu_items, 1, { nil, nil })
table.insert(menu_items, 1, { "Favorite", M.favorite })
table.insert(menu_items, 1, { "Awesome", M.awesome, beautiful.awesome_subicon })

M.main = awful.menu({ items = menu_items })

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

M.launcher = awful.widget.launcher(
  { image = beautiful.awesome_icon, menu = M.main }
)

-- Menubar configuration
menubar.utils.terminal = RC.terminal -- Set the terminal for applications that require it

-- }}}
