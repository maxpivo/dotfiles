local gmc = require('.gmc')
local common = require('.common')
local helper = require('.helper')

local _M = {}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- initialize

-- assuming $ herbstclient tag_status
-- 	#1	:2	:3	:4	.5	.6	.7	.8	.9

-- custom tag names
_M.tag_shows = {'一 ichi', '二 ni', '三 san', '四 shi', 
  '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū'}

-- initialize variable segment
_M.segment_windowtitle = '' -- empty string
_M.tags_status = {}         -- empty table

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- decoration

_M.separator = '%{B-}%{F' .. gmc.color['yellow500'] .. '}|%{B-}%{F-}'

-- Powerline Symbol
_M.right_hard_arrow = ""
_M.right_soft_arrow = ""
_M.left_hard_arrow  = ""
_M.left_soft_arrow  = ""

-- theme
_M.pre_icon    = '%{F' .. gmc.color['yellow500'] .. '}'
_M.post_icon   = '%{F-}'

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

function _M.get_statusbar_text(monitor)
    local text = ''
    
    -- draw tags, non zero based
    text = text .. '%{l}'
    for index = 1, #(_M.tags_status) do
        text = text .. _M.output_by_tag(monitor, _M.tags_status[index])
    end
    
    -- draw window title 
    text = text .. '%{r}'
    text = text .. _M.output_by_title()
  
    return text
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- each segments

function _M.output_by_tag(monitor, tag_status)
    local tag_index  = string.sub(tag_status, 2, 2)
    local tag_mark   = string.sub(tag_status, 1, 1)
    local index      = tonumber(tag_index)-- not a zero based array
    local tag_name   = _M.tag_shows[index]

    -- ----- pre tag

    local text_pre = ''
    if tag_mark == '#' then
        text_pre = '%{B' .. gmc.color['blue500'] .. '}'
                .. '%{F' .. gmc.color['black'] .. '}'
                .. '%{U' .. gmc.color['white'] .. '}%{+u}' 
                .. _M.right_hard_arrow
                .. '%{B' .. gmc.color['blue500'] .. '}'
                .. '%{F' .. gmc.color['white'] .. '}'
                .. '%{U' .. gmc.color['white'] .. '}%{+u}'
    elseif tag_mark == '+' then
        text_pre = '%{B' .. gmc.color['yellow500'] .. '}'
                .. '%{F' .. gmc.color['grey400'] .. '}'
    elseif tag_mark == ':' then
        text_pre = '%{B-}%{F' .. gmc.color['white'] .. '}'
                .. '%{U' .. gmc.color['red500'] .. '}%{+u}'
    elseif tag_mark == '!' then
        text_pre = '%{B' .. gmc.color['red500'] .. '}'
                .. '%{F' .. gmc.color['white'] .. '}'
                .. '%{U' .. gmc.color['white'] .. '}%{+u}'
    else
        text_pre = '%{B-}%{F' .. gmc.color['grey600'] .. '}%{-u}'
    end

    -- ----- tag by number

    -- clickable tags
    local text_name = '%{A:herbstclient focus_monitor '
                   .. '"' .. monitor .. '" && '
                   .. 'herbstclient use "' .. tag_index .. '":}'
                   .. ' ' .. tag_name ..' %{A} '
    
    -- non clickable tags
    -- local text_name = ' ' .. tag_name .. ' '

    -- ----- post tag

    local text_post = ""
    if (tag_mark == '#') then
        text_post = '%{B-}' 
                 .. '%{F' .. gmc.color['blue500'] .. '}' 
                 .. '%{U' .. gmc.color['red500'] .. '}%{+u}' 
                 .. _M.right_hard_arrow
    end

    text_clear = '%{B-}%{F-}%{-u}'

     
    return text_pre .. text_name .. text_post .. text_clear
end

function _M.output_by_title()
    local text = _M.segment_windowtitle .. ' ' .. _M.separator .. '  '

    return text
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- setting variables, response to event handler

function _M.set_tag_value(monitor)
    local command = 'herbstclient tag_status ' .. monitor
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close() 
        
    local raw = common.trim1(result)  
    _M.tags_status = common.split(raw, "\t")
end

function _M.set_windowtitle(windowtitle)
    local icon = _M.pre_icon .. '' .. _M.post_icon

    if (windowtitle == nil) then windowtitle = '' end
    
    windowtitle = common.trim1(windowtitle)
      
    _M.segment_windowtitle = ' ' .. icon ..
        ' %{B-}%{F' .. gmc.color['grey700'] .. '} ' .. windowtitle
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
