-- vim: ts=4 sw=4 noet ai cindent syntax=lua

--[[
Conky, a system monitor, based on torsmo
]]

conky.config = {
    out_to_x = false,
    out_to_console = true,
    short_units = true,
    update_interval = 1
}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- ansi

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- Initialize ANSI

ansiEscape    = ""

-- Foreground ansiors
ansiFgBlack   = ansiEscape .. "[30m" 
ansiFgRed     = ansiEscape .. "[31m"   
ansiFgGreen   = ansiEscape .. "[32m"
ansiFgYellow  = ansiEscape .. "[33m" 
ansiFgBlue    = ansiEscape .. "[34m"  
ansiFgPurple  = ansiEscape .. "[35m"
ansiFgCyan    = ansiEscape .. "[36m"   
ansiFgWhite   = ansiEscape .. "[37m"

-- Background ansiors
ansiBgBlack   = ansiEscape .. "[40m"  
ansiBgRed     = ansiEscape .. "[41m"   
ansiBgGreen   = ansiEscape .. "[42m"
ansiBgYellow  = ansiEscape .. "[43m" 
ansiBgBlue    = ansiEscape .. "[44m"  
ansiBgPurple  = ansiEscape .. "[45m"
ansiBgCyan    = ansiEscape .. "[46m"   
ansiBgWhite   = ansiEscape .. "[47m"

-- Special Character Conditions
ansiBoldOn       = ansiEscape .. "[1m"   
ansiBoldOff      = ansiEscape .. "[22m"
ansiItalicsOn    = ansiEscape .. "[3m"
ansiItalicsOff   = ansiEscape .. "[23m"
ansiUnderlineOn  = ansiEscape .. "[4m"
ansiUnderlineOff = ansiEscape .. "[24m"
ansiInvertOn     = ansiEscape .. "[7m"    
ansiInvertOff    = ansiEscape .. "[27m"

-- Reset to default configuration
ansiReset     = ansiEscape .. "[0m"

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- helper

helper = {}

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

-- ----- 

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

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- parts

parts = {}

-- user variables
local wlandev = 'wlp0s3f3u2'

-- shortcut
local _h = helper

-- constant
parts.arrow = ansiBoldOff .. ''

-- template variables: Color Indicator
local color_indicator_dark = {
  good      = ansiFgBlack,
  degraded  = ansiFgPurple,
  bad       = ansiFgRed 
}

local color_indicator_bright = {
  good      = ansiFgBlack,
  degraded  = ansiFgPurple,
  bad       = ansiFgRed 
}

local ci = color_indicator_bright

-- transition image
function parts.transition(decoIcon, decoBg, decoFg)
   text = '^bg(' .. decoBg .. ')' 
       .. '^fg(' .. decoFg .. ')' .. decoIcon

  return text
end

-- Newline
parts.newline = [[
  
]]

-- Time
parts.time = _h.common('', nil, '${time %H:%M }')

-- Date
parts.date = _h.common('', nil, '${time %D}')

-- Date Time (time for dating)
parts.datetime =  ansiBgWhite .. ansiFgRed .. '  '
  .. ansiBgRed .. ansiFgWhite .. parts.arrow
  .. ansiBoldOn .. ' ${time %D} '
  .. ansiBgWhite .. ansiFgRed .. parts.arrow
  .. ' ${time %H:%M } '
  .. ansiReset .. ansiFgWhite .. parts.arrow
  .. ansiReset
  
-- Title
parts.title = ansiBgWhite .. ansiFgBlue .. parts.arrow
  .. ' Command Line Interface '
  .. ansiBgBlue .. ansiFgWhite .. parts.arrow
  .. ansiBoldOn .. ' System Monitoring '
  .. ansiReset .. ansiFgBlue .. parts.arrow
  .. ansiReset

-- Volume
local volume_command = [[amixer get Master | tail -1 | sed 's/.*\[\([0-9]*%\)\].*/\1/']]

parts.volume = _h.common('', 'Volume  ', "${execi 1 " .. volume_command .. "}")

-- Host
parts.host = _h.common('', 'Host    ',
  ansiUnderlineOn .. '$nodename' .. ansiUnderlineOff) 

-- Uptime
parts.uptime = _h.common('', 'Uptime  ', '$uptime')

-- Memory
parts.mem = _h.common('', 'RAM     ', '$mem/$memmax')

-- SSID
parts.ssid = _h.common('', 'ESSID   ', '$wireless_essid')

-- Lua Function Demo 
-- https://github.com/brndnmtthws/conky/issues/62

function _h.exec(command)
    local file = assert(io.popen(command, 'r'))
    local s = file:read('*all')
    file:close()

    s = string.gsub(s, '^%s+', '') 
    s = string.gsub(s, '%s+$', '') 
    s = string.gsub(s, '[\n\r]+', ' ')

    return s
end

-- read once
local machine = _h.exec('uname -r')
machine = ansiItalicsOn .. machine .. ansiItalicsOff  

parts.machine = _h.common('', nil, machine)

-- Media Player Daemon
parts.mpd = [[\
${if_mpd_playing}\
]] .. ' ' .. _h.icon('') 
.. _h.value(' ${mpd_artist 20} ')
.. _h.icon('')
.. _h.value(' ${mpd_title 30}') 
.. '                     ' .. [[
${else}]] .. ' '.. _h.icon('') .. ' '
.. _h.label('Pause     ')
.. '                     ' .. [[${endif}\
]]

-- CPU temperature:
local cputemp = [[\
${if_match ${acpitemp}<45}\
]] .. _h.value('${acpitemp}°C', ci.good) .. [[
${else}${if_match ${acpitemp}<55}\
]] .. _h.value('${acpitemp}°C', ci.degraded) .. [[
${else}${if_match ${acpitemp}>=55}\
]] .. _h.value('${acpitemp}°C', ci.bad) .. [[
${endif}${endif}${endif}\
]]

parts.cputemp = _h.common('', 'CPU Temp', cputemp)


-- Network
local download = _h.icon('') .. [[\
${if_match ${downspeedf ]] .. wlandev .. [[}<1000}\
]] .. _h.value('${downspeed ' .. wlandev .. '}', ci.good) .. [[
${else}${if_match ${downspeedf ]] .. wlandev .. [[}<3000}\
]] .. _h.value('${downspeed ' .. wlandev .. '}', ci.degraded) .. [[
${else}${if_match ${downspeedf ]] .. wlandev .. [[}>=3000}\
]] .. _h.value('${downspeed ' .. wlandev .. '}', ci.bad) .. [[
${endif}${endif}${endif}\
]]

local upload = _h.icon('') .. [[\
${if_match ${upspeedf ]] .. wlandev .. [[}<300}\
]] .. _h.value('${upspeed ' .. wlandev .. '}', ci.good) .. [[
${else}${if_match ${upspeedf ]] .. wlandev .. [[}<800}\
]] .. _h.value('${upspeed ' .. wlandev .. '}', ci.degraded) .. [[
${else}${if_match ${upspeedf ]] .. wlandev .. [[}>=800}\
]] .. _h.value('${upspeed ' .. wlandev .. '}', ci.bad) .. [[
${endif}${endif}${endif}\
]]

parts.network = _h.common(' ', nil, download .. upload .. '          ')

-- Memory
local memory = [[\
${if_match ${memperc}<30}\
]] .. _h.value('${memeasyfree}', ci.good) .. [[
${else}${if_match ${memperc}<70}\
]] .. _h.value('${memeasyfree}',ci.degraded) .. [[
${else}${if_match ${memperc}>=70}\
]] .. _h.value('${memeasyfree}', ci.bad) .. [[
${endif}${endif}${endif}\
]]

parts.memory = _h.common('', 'Memory  ', memory)


-- CPU 0
local cpu0 = [[\
${if_match ${cpu cpu0}<50}\
]] .. _h.value('${cpu cpu0}%', ci.good) .. [[
${else}${if_match ${cpu cpu0}<60}\
]] .. _h.value('${cpu cpu0}%',ci.degraded) .. [[
${else}${if_match ${cpu cpu0}<=100}\
]] .. _h.value('${cpu cpu0}%', ci.bad) .. [[
${endif}${endif}${endif}\
]]

parts.cpu0 = _h.common('', 'CPU Load', cpu0)

-- Battery
local battery = [[\
${if_match ${battery_percent}<30}\
]] .. _h.value('${battery_percent}%', ci.bad) .. [[
${else}${if_match ${battery_percent}<70}\
]] .. _h.value('${battery_percent}%', ci.degraded) .. [[
${else}${if_match ${battery_percent}>=70}\
]] .. _h.value('${battery_percent}%', ci.good) .. [[
${endif}${endif}${endif}\
]]

parts.battery = _h.common('', 'Battery ', battery)

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ---
-- main

-- shortcut
local _h = helper

--[[
-- if you care about performance, comment-out this variable.
disabled = ''
    .. parts.title     
    .. parts.newline    
    .. parts.newline
    .. parts.date
    .. parts.time    
    .. parts.newline 
    .. parts.mem    
]]

enabled = ''
    .. parts.newline 
    .. parts.newline

    .. parts.uptime
    .. parts.newline
    .. parts.host
    .. parts.machine    
    .. parts.newline
    
    .. parts.volume
    .. parts.newline
    .. parts.mpd
    .. parts.newline
    .. parts.newline 
       
    .. parts.datetime   
    .. parts.newline 
    .. parts.newline

    .. parts.cpu0        
    .. parts.newline
    .. parts.cputemp
    .. parts.newline
    .. parts.memory
    .. parts.newline
    .. parts.battery    
      
    .. parts.newline
    .. parts.newline
    .. parts.ssid
    .. parts.network
    .. parts.newline 
    .. parts.newline
    
conky.text = _h.gototopleft() .. [[\
]] .. enabled .. [[
]]
