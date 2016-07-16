theme.font        = "Tamsyn 10"  -- "Terminus 8" -- "Sans 8"
theme.taglist_font  = "Inconsolata Medium 10"

theme.bg_normal     = "#000000cc"   -- "#1c1c1c99"
theme.bg_focus      = "#7985A366"
theme.bg_urgent     = "#ad3737"     -- "#A3666666"
--theme.bg_minimize   = "#444444"
--theme.bg_systray    = theme.bg_normal

theme.fg_normal     = "#C5C5C5"
theme.fg_focus      = "#E4E4E4"
theme.fg_urgent     = "#ffffff"     -- "#A36666"
--theme.fg_minimize   = "#ffffff"

theme.border_width  = 7
theme.border_normal = "#c9c925cc"
theme.border_focus  = "#5c5dadcc"
theme.border_marked = "#A3BA8C"

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- Example:

theme.taglist_bg_focus = "#c9c925"
--theme.taglist_bg_focus = "png:" .. theme_path .. "misc/copycat-holo/taglist_bg_focus.png"
theme.taglist_fg_focus = "#000000cc"


theme.tasklist_bg_normal = "#000000"
--theme.tasklist_bg_normal = "png:" .. theme_path .. "misc/copycat-holo/bg_focus.png"
theme.tasklist_bg_focus  = "#ccccff" -- "#c9c925"
--theme.tasklist_bg_focus  = "png:" .. theme_path .. "misc/copycat-holo/bg_focus_noline.png"
theme.tasklist_fg_focus  = "#000000cc"

theme.titlebar_bg_focus = "#c9c925cc"
theme.titlebar_fg_focus = "#000000cc"

-- Display the taglist squares
theme.taglist_squares_sel   = theme_path .. "taglist/copycat-zenburn/squarefz.png"
theme.taglist_squares_unsel = theme_path .. "taglist/copycat-zenburn/squareza.png"
-- theme.taglist_squares_sel      = theme_path .. "taglist/copycat-blackburn/square_sel.png"
-- theme.taglist_squares_unsel    = theme_path .. "taglist/copycat-blackburn/square_unsel.png"

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_submenu_icon  = theme_path .. "misc/default/submenu.png"
theme.menu_height = 20      -- 15
theme.menu_width  = 180     -- 100
--theme.menu_context_height = 20

theme.menu_bg_focus = "#c9c925cc"     -- "#7985A3"
theme.menu_fg_focus = "#000000cc"
theme.menu_bg_normal = "#454545"

theme.menu_border_color = "#5c5dad" -- "#7985A3"
theme.menu_border_width = 1

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
