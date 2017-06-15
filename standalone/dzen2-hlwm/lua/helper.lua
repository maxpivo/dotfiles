local _M = {}

local common = require('.common')

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helpers

-- script arguments
function _M.get_monitor(arguments)
    -- no ternary operator, using expression
    return (#arguments > 0) and tonumber(arguments[1]) or 0
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- geometry calculation

function _M.get_geometry(monitor)
    local command = 'herbstclient monitor_rect ' .. monitor
    local handle = io.popen(command)
    local result = handle:read("*a")
    handle:close()

    if (result == nil or result == '') then
        print('Invalid monitor ' .. monitors)
        os.exit()
    end      
        
    local raw = common.trim1(result)  
    local geometry = common.split(raw, ' ')
    
    return geometry
end

function _M.get_top_panel_geometry(height, geometry)
    -- geometry has the format X Y W H
    return tonumber(geometry[1]), tonumber(geometry[2]),
           tonumber(geometry[3]), height
end

function _M.get_bottom_panel_geometry(height, geometry)
    -- geometry has the format X Y W H
    return tonumber(geometry[1]) + 0, tonumber(geometry[4]) - height, 
           tonumber(geometry[3]) - 0, height
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- dzen Parameters

function _M.get_dzen2_parameters(monitor, panel_height)
    local geometry = _M.get_geometry(monitor)
    local xpos, ypos, width, height = _M.get_top_panel_geometry(
        panel_height, geometry)
    
    local bgcolor = '#000000'
    local fgcolor = '#ffffff'
    local font    = '-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*'
  
    local parameters = ""
        .. " -x " .. tostring(xpos)  .. " -y " .. tostring(ypos)
        .. " -w " .. tostring(width) .. " -h " .. tostring(height)
        .. " -ta l -bg '" .. bgcolor .. "' -fg '" .. fgcolor .. "'"
        .. " -title-name dzentop"
        .. " -fn '" .. font .. "'"

    return parameters
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
