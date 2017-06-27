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
    local column = common.split(event, "\t")
    local origin = column[1] -- non zero based

    local tag_cmds = {'tag_changed', 
         'tag_flags', 'tag_added', 'tag_removed'}
    local title_cmds = {'window_title_changed', 'focus_changed'}

    if origin == 'reload' then
        os.execute('pkill lemonbar')
    elseif origin == 'quit_panel' then
        os.exit()
    elseif common.has_value(tag_cmds, origin) then
        output.set_tag_value(monitor)
    elseif common.has_value(title_cmds, origin) then
        local title = (#column > 2) and (column[3]) or ''
        output.set_windowtitle(title)
    end
end

function _M.content_init(monitor, pipe_lemon_out)
    -- initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')

    local text = output.get_statusbar_text(monitor)
    pipe_lemon_out:write(text .. "\n")
    pipe_lemon_out:flush()
end

function _M.content_walk(monitor, pipe_lemon_out)    
    -- start a pipe
    command_in = 'herbstclient --idle'
    local pipe_in  = assert(io.popen(command_in,  'r'))
    local text = ''
  
    -- wait for each event, trim newline 
    for event in pipe_idle_in:lines() do
        _M.handle_command_event(monitor, common.trim1(event))
       
        text = output.get_statusbar_text(monitor)
        pipe_lemon_out:write(text .. "\n")
        pipe_lemon_out:flush()
    end -- for loop
   
    pipein:close()
end

function _M.run_lemon(monitor, parameters) 
    local command_out  = 'lemonbar ' .. parameters
    local pipe_lemon_out = assert(io.popen(command_out, 'w'))
    
    _M.content_init(monitor, pipe_lemon_out)
    _M.content_walk(monitor, pipe_lemon_out) -- loop for each event
        
    pipe_lemon_out:close()
end

function _M.detach_lemon(monitor, parameters)
    local pid_lemon = posix.fork()

    if pid_lemon == 0 then -- this is the child process
        _M.run_lemon(monitor, parameters)
    else             -- this is the parent process
        -- nothing
    end
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
