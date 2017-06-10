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
    return geometry[0], geometry[1], geometry[2], height
end

function _M.get_bottom_panel_geometry(height, geometry)
    -- geometry has the format X Y W H
    return geometry[0], (geometry[3]-height), geometry[2], height
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- lemon Parameters

function _M.get_lemon_parameters(monitor, panel_height)
    -- calculate geometry
    local geometry = _M.get_geometry(monitor)
    local xpos, ypos, width, height = _M.get_top_panel_geometry(
        panel_height, geometry)

    -- geometry: -g widthxheight+x+y
    local geom_res = width .. 'x' .. height 
        .. '+' .. xpos .. '+' .. xpos

    -- color, with transparency    
    local bgcolor = "'#aa000000'"
    local fgcolor = "'#ffffff'"

    -- XFT: require lemonbar_xft_git 
    local font_takaop  = "takaopgothic-9"
    local font_bottom  = "monospace-9"
    local font_symbol  = "PowerlineSymbols-11"
    local font_awesome = "FontAwesome-9"
  
    local parameters = ""
        .. " -g "..geom_res.." -u 2"
        .. " -B "..bgcolor.." -F "..fgcolor
        .. " -f "..font_takaop
        .. " -f "..font_awesome
        .. " -f "..font_symbol
        
    return parameters
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
