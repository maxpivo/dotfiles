-- Standard awesome library
local awful = require("awful")

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- {{{ Tags

-- Define a tag table which hold all screen tags.
--[[
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, s, layouts[1])
end
--]]

tags = {
--  names  = { "term", "net", "edit", "place", 5, 6, 7, 8, 9 },
    names  = {
      "❶ 一 term", "❷ 二 net", "❸ 三 edit",
      "❹ 四 place", "❺ 五 mail",
      " ❻ 六", "❼ 七", " ❽ 八", "❾ 九" },

    layout = {
      RC.layouts[1], RC.layouts[2], RC.layouts[4],
      RC.layouts[5], RC.layouts[6], RC.layouts[12],
      RC.layouts[9], RC.layouts[3], RC.layouts[7]
    }
}

RC.tags = {}
for s = 1, screen.count() do
     -- Each screen has its own tag table.
     RC.tags[s] = awful.tag(tags.names, s, tags.layout)
end
-- }}}
