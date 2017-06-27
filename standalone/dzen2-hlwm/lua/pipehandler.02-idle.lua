-- luaposix available in AUR
local posix = require "posix"

local common = require('.common')
local helper = require('.helper')
local output = require('.output')

local _M = {}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- pipe

function _M.handle_command_event(monitor, event)
    -- find out event origin
    column = common.split(event, "\t")
    origin = column[1] -- non zero based

    tag_cmds = {'tag_changed', 'tag_flags', 'tag_added', 'tag_removed'}
    title_cmds = {'window_title_changed', 'focus_changed'}

    if origin == 'reload' then
        os.execute('pkill dzen2')
    elseif origin == 'quit_panel' then
        os.exit()
    elseif common.has_value(tag_cmds, origin) then
        output.set_tag_value(monitor)
    elseif common.has_value(title_cmds, origin) then
        local title = (#column > 2) and (column[3]) or ''
        output.set_windowtitle(title)
    end
end

function _M.content_init(monitor, pipe_dzen2_out)
    -- initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')

    local text = output.get_statusbar_text(monitor)
    pipe_dzen2_out:write(text .. "\n")
    pipe_dzen2_out:flush()
end

function _M.content_walk(monitor, pipe_dzen2_out)    
    -- start a pipe
    command_in = 'herbstclient --idle'
    local pipe_idle_in  = assert(io.popen(command_in,  'r'))
    local text = ''

    -- wait for each event, trim newline 
    for event in pipe_idle_in:lines() do
        _M.handle_command_event(monitor, common.trim1(event))
    
        text = output.get_statusbar_text(monitor)
        pipe_dzen2_out:write(text .. "\n")
        pipe_dzen2_out:flush()
    end -- for loop
   
    pipe_idle_in:close()
end

function _M.run_dzen2(monitor, parameters) 
    local command_out    = 'dzen2 ' .. parameters
    local pipe_dzen2_out = assert(io.popen(command_out, 'w'))
    
    _M.content_init(monitor, pipe_dzen2_out)
    _M.content_walk(monitor, pipe_dzen2_out) -- loop for each event
        
    pipe_dzen2_out:close()
end

function _M.detach_dzen2(monitor, parameters)
    local pid_dzen2 = posix.fork()

    if pid_dzen2 == 0 then -- this is the child process
        _M.run_dzen2(monitor, parameters)
    else             -- this is the parent process
        -- nothing
    end
end

function _M.detach_transset()
    local pid_transset = posix.fork()

    if pid_transset == 0 then -- this is the child process
        common.sleep(1)
        os.execute('transset .8 -n dzentop >/dev/null') 
    else                      -- this is the parent process
        -- nothing
    end
end


-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
