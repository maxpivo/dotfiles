-- Standard awesome library
local awful = require("awful")
-- Theme handling library
local beautiful = require("beautiful")
-- Required library
local menugen = require("modules.menugen")
local menu_blackarch = require("main.menu-blackarch")

local M = {}  -- menu
local _M = {} -- module

-- reading
-- https://awesomewm.org/wiki/Awful.menu

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- This is used later as the default terminal and editor to run.
-- local terminal = "xfce4-terminal"
local terminal = RC.vars.terminal

-- Variable definitions
-- This is used later as the default terminal and editor to run.
local editor = os.getenv("EDITOR") or "nano"
local editor_cmd = terminal .. " -e " .. editor

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

M.awesome = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "Terminal", terminal },
   { "Shutdown/Logout", "oblogout" },
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

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

function _M.get()

  --[[
  -- Main Menu
  local menu_items = {
    { "awesome", M.awesome, beautiful.awesome_subicon },
  	{ "open terminal", terminal },
  	{ "blackarch", menu_blackarch() },
    { "network", M.network_main },
  	{ "favorite", M.favorite }
  }
  ]]

  local menu_items = require("menugen").build_menu()
  table.insert(menu_items, 1, { nil, nil })
  table.insert(menu_items, 1, { "Favorite", M.favorite })
  table.insert(menu_items, 1, { "Awesome", M.awesome, beautiful.awesome_subicon })

  return menu_items
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

return setmetatable({}, { __call = function(_, ...) return _M.get(...) end })
