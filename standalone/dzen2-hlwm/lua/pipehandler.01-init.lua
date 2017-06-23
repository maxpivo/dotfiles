-- luaposix available in AUR
local posix = require "posix"

local common = require('.common')
local helper = require('.helper')
local output = require('.output')

local _M = {}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- pipe

function _M.content_init(monitor, pipe_dzen2_out)
    -- initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')

    local text = output.get_statusbar_text(monitor)
    pipe_dzen2_out:write(text .. "\n")
    pipe_dzen2_out:flush()
end

function _M.run_dzen2(monitor, parameters) 
    local command_out    = 'dzen2 ' .. parameters .. ' -p'
    local pipe_dzen2_out = assert(io.popen(command_out, 'w'))
    
    _M.content_init(monitor, pipe_dzen2_out)
    pipe_dzen2_out:close()
end

function _M.detach_dzen2(monitor, parameters)
    local pid = posix.fork()

    if pid == 0 then -- this is the child process
        _M.run_dzen2(monitor, parameters)
    else             -- this is the parent process
        -- nothing
    end
end

function _M.detach_transset()
    local pid = posix.fork()

    if pid == 0 then -- this is the child process
        common.sleep(1)
        os.execute('transset .8 -n dzentop >/dev/null') 
    else             -- this is the parent process
        -- nothing
    end
end


-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
