-- Awesome 3.5 Compatible Configuration
-- Author: Epsiarto Nurwijayadi (epsi.nurwijayadi@gmail.com)
-- Description: Awesome config, tested on Arch's awesome 3.5.9

-- {{{ Required libraries
-- Standard Awesome Library
local awful     = require("awful")
awful.rules     = require("awful.rules")
require("awful.autofocus") -- do not delete autofocus
-- Theme handling library
local beautiful = require("beautiful")
-- Required library
local menubar = require("menubar")
-- Optional: it can be removed safely
-- naughtyfication from command line to awesome-client.
naughty = require('naughty')
-- }}}

RC = {} -- global namespace, on top before require any modules
RC.vars = require("main.user-variables")

local config_path = awful.util.getdir("config") .. "/"
-- {{{ Error handling -- }}}
dofile(config_path .. "main/error-handling.lua")
-- {{{ Themes -- }}}
dofile(config_path .. "main/theme.lua")

-- Custom Local Library
local main = {
    layouts = require("main.layouts"),
    tags    = require("main.tags"),
    menu    = require("main.menu"),
    rules   = require("main.rules"),
}
-- Custom Local Library: Keys and Mouse Binding
local binding = {
    globalbuttons = require("binding.globalbuttons"),
    clientbuttons = require("binding.clientbuttons"),
    globalkeys    = require("binding.globalkeys"),
    bindtotags    = require("binding.bindtotags"),
    clientkeys    = require("binding.clientkeys")
}

-- Custom Dynamic Local Wibox Statusbar Module
local sbm = RC.vars.statusbarmodule
local sbm_name = "anybox." .. sbm .. ".statusbar"
local statusbar = require(sbm_name) -- after theme

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

os.execute("nm-applet &")
os.execute("compton &")    -- xcompmgr

-- {{{ Layouts
-- Table of layouts to cover with awful.layout.inc, order matters.
-- a variable needed in main.tags, and statusbar
RC.layouts = main.layouts()
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
-- a variable needed in rules, tasklist, and globalkeys
RC.tags = main.tags()
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
RC.mainmenu = awful.menu({ items = main.menu() }) -- in globalkeys

-- a variable needed in statusbar (helper)
RC.launcher = awful.widget.launcher(
  { image = beautiful.awesome_icon, menu = RC.mainmenu }
)

-- Menubar configuration
menubar.utils.terminal = RC.vars.terminal -- Set the terminal for applications that require it

-- }}}

-- {{{ Mouse and Key bindings
RC.globalkeys = binding.globalkeys()
RC.globalkeys = binding.bindtotags(RC.globalkeys)

-- Set root
root.buttons(binding.globalbuttons())
root.keys(RC.globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
--dofile(config_path .. "/main/" .. "rules.lua")
awful.rules.rules = main.rules(
    binding.clientkeys(),
    binding.clientbuttons()
)
-- }}}


statusbar()

--awful.util.spawn("nm-applet")

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
