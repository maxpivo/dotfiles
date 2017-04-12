-- vim: ts=4 sw=4 noet ai cindent syntax=lua-- global

helper = {}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---

-- Lua Function Demo 
-- https://github.com/brndnmtthws/conky/issues/62

function helper.exec(command)
    local file = assert(io.popen(command, 'r'))
    local s = file:read('*all')
    file:close()

    s = string.gsub(s, '^%s+', '') 
    s = string.gsub(s, '%s+$', '') 
    s = string.gsub(s, '[\n\r]+', ' ')

    return s
end


function helper.gototopleft()
  return helper.exec('tput cup 0 0') 
--  return ''
end

function helper.newline()
  return helper.exec('echo "\n\n\n\n"') 
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---

-- template variables
local ansiPresetDark = {
  icon      = ansiFgRed,
  label     = ansiFgBlack .. ansiBoldOn,
  value     = ansiFgBlue .. ansiBoldOff
}

local ansiPresetBright = {
  icon      = ansiFgRed,
  label     = ansiFgBlack .. ansiBoldOn,
  value     = ansiFgBlack .. ansiBoldOff
}

local ansiPreset = ansiPresetBright

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---

function helper.icon(text, ansi)
  ansi = ansi or ansiPreset.icon
 
  return ansi .. ' ' .. text .. ' '
end

function helper.label(text, ansi)
  ansi = ansi or ansiPreset.label

  return ansi .. text
end

function helper.value(text, ansi)
  ansi = ansi or ansiPreset.value

  return ansi .. text 
end

function helper.common(icon, label, value)
  text=''
  
  if icon  then text = text .. ' ' .. helper.icon(icon)   end  
  if label then text = text .. ' ' .. helper.label(label) end  
  if value then text = text .. ' ' .. helper.value(value) end

  return text
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- miscellanous

function helper.progressbar(value)
  -- Predefined
  maximum=100
  width=25
  symbol="=" 

  -- number of block
  count = (value * width) // maximum
    
  -- Create the progress bar string.
  row=''
  for i=1,count do row = row .. symbol end
  for i=count,width do row = row .. ' ' end

  return ' [' .. row .. '] '
end
