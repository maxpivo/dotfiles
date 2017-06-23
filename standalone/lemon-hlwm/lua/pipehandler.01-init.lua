-- luaposix available in AUR
local posix = require "posix"

local common = require('.common')
local helper = require('.helper')
local output = require('.output')

local _M = {}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- pipe

function _M.content_init(monitor, pipe_lemon_out)
    -- initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')

    local text = output.get_statusbar_text(monitor)
    pipe_lemon_out:write(text .. "\n")
    pipe_lemon_out:flush()
end

function _M.run_lemon(monitor, parameters) 
    local command_out  = 'lemonbar ' .. parameters .. ' -p'
    local pipe_lemon_out = assert(io.popen(command_out, 'w'))
    
    _M.content_init(monitor, pipe_lemon_out)       
    pipe_lemon_out:close()
end

function _M.detach_lemon(monitor, parameters)
    local pid = posix.fork()

    if pid == 0 then -- this is the child process
        _M.run_lemon(monitor, parameters)
    else             -- this is the parent process
        -- nothing
    end
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
