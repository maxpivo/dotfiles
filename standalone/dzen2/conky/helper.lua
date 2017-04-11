-- vim: ts=4 sw=4 noet ai cindent syntax=lua-- global

helper = {}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- constant


-- glyph icon decoration
local decoPath = 'Documents/standalone/dzen2/assets/xbm'

-- diagonal corner
helper.decoCornerTopLeft     = '^i(' .. decoPath .. '/dc-024-tl.xbm)'
helper.decoCornerTopRight    = '^i(' .. decoPath .. '/dc-024-tr.xbm)'
helper.decoCornerBottomLeft  = '^i(' .. decoPath .. '/dc-024-bl.xbm)'
helper.decoCornerBottomRight = '^i(' .. decoPath .. '/dc-024-br.xbm)'

-- single arrow and double arrow
helper.decoSingleArrowLeft  = '^i(' .. decoPath .. '/sa-024-l.xbm)'
helper.decoSingleArrowRight = '^i(' .. decoPath .. '/sa-024-r.xbm)'
helper.decoDoubleArrowLeft  = '^i(' .. decoPath .. '/da-024-l.xbm)'
helper.decoDoubleArrowRight = '^i(' .. decoPath .. '/da-024-r.xbm)'


-- http://fontawesome.io/
local fontAwesome = '^fn(FontAwesome-9)'

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- initialization

--local colorPreset = nil
 
-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---

function helper.icon(text, color)
  color = color or colorPreset.icon

  local preIcon  = '^fg(' .. color .. ')' .. fontAwesome
  local postIcon = '^fn()^fg()'
  
  return ' ' .. preIcon .. text .. postIcon .. ' '
end

function helper.label(text, color)
  color = color or colorPreset.label

  return '^fg(' .. color .. ')' .. text
end

function helper.separator(color)
  color = color or colorPreset.separator

  return '^fg(' .. color .. ')' .. '|'
end

function helper.value(text, color)
  color = color or colorPreset.value

  return '^fg(' .. color .. ')' .. text
end

function helper.common(icon, label, value, colorBg)

  colorBg = colorBg or colorPreset.background
  text=''
  
  if colorBg then text = text .. '^bg(' .. colorBg .. ')' end
  if not colorBg then text = helper.separator() end  
  if icon then text = text .. ' ' .. helper.icon(icon) end  
  if label then text = text .. ' ' .. helper.label(label) end  
  if value then text = text .. ' ' .. helper.value(value) .. ' ' end

  return text
end

