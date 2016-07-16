--local layout_icons = "default-white"
--local layout_icons = "default-black"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- You can use your own layout icons like this:

local layout_icons = "copycat-multicolor"
local layout_path = theme_path .. "layouts/" .. layout_icons .. "/"

-- default awful related
theme.layout_dwindle        = layout_path .. "dwindle.png"
theme.layout_fairh          = layout_path .. "fairh.png"
theme.layout_fairv          = layout_path .. "fairv.png"
theme.layout_floating       = layout_path .. "floating.png"
theme.layout_magnifier      = layout_path .. "magnifier.png"
theme.layout_max            = layout_path .. "max.png"
theme.layout_spiral         = layout_path .. "spiral.png"
theme.layout_tilebottom     = layout_path .. "tilebottom.png"
theme.layout_tileleft       = layout_path .. "tileleft.png"
theme.layout_tile           = layout_path .. "tile.png"
theme.layout_tiletop        = layout_path .. "tiletop.png"

-- lain related
theme.layout_termfair          = layout_path .. "fairh.png"
theme.layout_uselessfair       = layout_path .. "fairv.png"
theme.layout_uselessfairh      = layout_path .. "fairh.png"
theme.layout_uselessdwindle    = layout_path .. "dwindle.png"
theme.layout_uselesstile       = layout_path .. "tile.png"
theme.layout_uselesstiletop    = layout_path .. "tiletop.png"
theme.layout_uselesstileleft   = layout_path .. "tileleft.png"
theme.layout_uselesstilebottom = layout_path .. "tilebottom.png"
theme.layout_uselesspiral      = layout_path .. "spiral.png"

--

layout_icons = "default-lain-white"
layout_path = theme_path .. "layouts/" .. layout_icons .. "/"

-- lain related
theme.layout_centerfair     = layout_path .. "centerfair.png"
theme.layout_centerwork     = layout_path .. "centerwork.png"
theme.layout_cascade        = layout_path .. "cascade.png"
theme.layout_cascadetile    = layout_path .. "cascadebrowse.png"

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- awful layout
theme.layout_txt_tile               = "[t]"
theme.layout_txt_tileleft           = "[l]"
theme.layout_txt_tilebottom         = "[b]"
theme.layout_txt_tiletop            = "[tt]"
theme.layout_txt_fairv              = "[fv]"
theme.layout_txt_fairh              = "[fh]"
theme.layout_txt_spiral             = "[s]"
theme.layout_txt_dwindle            = "[d]"
theme.layout_txt_max                = "[m]"
theme.layout_txt_fullscreen         = "[F]"
theme.layout_txt_magnifier          = "[M]"
theme.layout_txt_floating           = "[|]"
theme.layout_txt_floating           = "[*]"

-- lain layout related
theme.layout_txt_cascade            = "[cascade]"
theme.layout_txt_cascadetile        = "[cascadetile]"
theme.layout_txt_centerwork         = "[centerwork]"
theme.layout_txt_termfair           = "[termfair]"
theme.layout_txt_centerfair         = "[centerfair]"
theme.layout_txt_uselessfair        = "[uf]"
theme.layout_txt_uselessfairh       = "[ufh]"
theme.layout_txt_uselesspiral       = "[us]"
theme.layout_txt_uselessdwindle     = "[ud]"
theme.layout_txt_uselesstile        = "[ut]"
theme.layout_txt_uselesstileleft    = "[utl]"
theme.layout_txt_uselesstiletop     = "[utt]"
theme.layout_txt_uselesstilebottom  = "[utb]"

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
