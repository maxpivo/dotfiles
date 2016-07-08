-- Standard awesome library
local awful = require("awful")

-- Copycat Killer library
local lain = require("lain")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Table of layouts to cover with awful.layout.inc, order matters.
-- local layouts =
RC.layouts =
{
    awful.layout.suit.floating,           -- 1:

    lain.layout.uselesstile,              -- 2:
    lain.layout.uselesstile.left,         -- 3:
    lain.layout.uselesstile.bottom,       -- 4:
    lain.layout.uselesstile.top,          -- 5:

--    awful.layout.suit.tile,             -- 2:
--    awful.layout.suit.tile.left,        -- 3:
--    awful.layout.suit.tile.bottom,      -- 4:
--    awful.layout.suit.tile.top,         -- 5:

    lain.layout.uselessfair,              -- 6:
    lain.layout.uselessfair,              -- 7:

--    awful.layout.suit.fair,             -- 6:
--    awful.layout.suit.fair.horizontal,  -- 7:

    lain.layout.uselesspiral,             -- 8:
    lain.layout.uselesspiral.dwindle,     -- 9:

    awful.layout.suit.spiral,             -- 8:
    awful.layout.suit.spiral.dwindle,     -- 9:

    awful.layout.suit.max,                -- 10:
    awful.layout.suit.max.fullscreen,     -- 11:
    awful.layout.suit.magnifier           -- 12:
}
-- }}}
