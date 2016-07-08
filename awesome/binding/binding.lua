-- Standard awesome library
local awful = require("awful")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- {{{ Mouse bindings
dofile(awful.util.getdir("config") .. "/binding/" .. "buttons.lua")
-- }}}

-- {{{ Key bindings
dofile(awful.util.getdir("config") .. "/binding/" .. "globalkeys.lua")
dofile(awful.util.getdir("config") .. "/binding/" .. "bindtotags.lua")
dofile(awful.util.getdir("config") .. "/binding/" .. "clientkeys.lua")

-- Set keys
root.keys(globalkeys)
-- }}}
