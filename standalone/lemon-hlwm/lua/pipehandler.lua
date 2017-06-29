-- luaposix available in AUR
local posix = require "posix"

local common = require('.common')
local helper = require('.helper')
local output = require('.output')

local _M = {}

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helper

-- because os.clock function will hogs your cpu
function _M.os_sleep(n)
  os.execute('sleep ' .. tonumber(n))
end

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
    elseif origin == 'interval' then
        output.set_datetime()
    end
end

function _M.content_init(monitor, pipe_lemon_out)
    -- initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')
    output.set_datetime()

    local text = output.get_statusbar_text(monitor)
    pipe_lemon_out:write(text .. "\n")
    pipe_lemon_out:flush()
end

function _M.content_event_idle(pipe_cat_out)
    local pid_idle = posix.fork()

    if pid_idle == 0 then -- this is the child process
        -- start a pipe
        command_in = 'herbstclient --idle'
        local pipe_in  = assert(io.popen(command_in,  'r'))
  
        -- wait for each event 
        for event in pipe_in:lines() do
            posix.write(pipe_cat_out, event)
            io.flush()
        end -- for loop
   
        pipe_in:close()
    else             -- this is the parent process
        -- nothing
    end
end

function _M.content_event_interval(pipe_cat_out) 
    local pid_interval = posix.fork()

    if pid_interval == 0 then -- this is the child process
        while true do
            posix.write(pipe_cat_out, "interval\n")
            io.flush() 

            _M.os_sleep(1)
        end
    else             -- this is the parent process
        -- nothing
    end
end

function _M.content_walk(monitor, pipe_lemon_out)  
    rd, wr = posix.pipe()

    _M.content_event_idle(wr)
    _M.content_event_interval(wr)

    local bufsize = 4096
    local event = ''

    while true do
        -- wait for next event, trim newline
        event = common.trim1(posix.read(rd, bufsize))
        if event == nil or #event == 0 then break end
    
        _M.handle_command_event(monitor, event)    
    
        text = output.get_statusbar_text(monitor)
        pipe_lemon_out:write(text .. "\n")
        pipe_lemon_out:flush()
    end -- not using for loop

    posix.close(rd)
    posix.close(wr)
end

function _M.run_lemon(monitor, parameters) 
    -- no bidirectional in Lua, using shell pipe instead
    local command_out  = 'lemonbar ' .. parameters .. ' | sh'
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

function _M.detach_lemon_conky(parameters)
    local pid_conky = posix.fork()

    if pid_conky == 0 then -- this is the child process
        local cmd_out  = 'lemonbar ' .. parameters
        local pipe_out = assert(io.popen(cmd_out, 'w'))

        local dirname  = debug.getinfo(1).source:match("@?(.*/)")
        local path     = dirname .. "../conky"
        local cmd_in   = 'conky -c ' .. path .. '/conky.lua'
        local pipe_in  = assert(io.popen(cmd_in,  'r'))

        for line in pipe_in:lines() do
            pipe_out:write(line.."\n")
            pipe_out:flush()
        end -- for loop
   
        pipe_in:close()    
        pipe_out:close()
    else                   -- this is the parent process
        -- nothing
    end
end

function _M.kill_zombie()
    os.execute('pkill -x dzen2')
    os.execute('pkill -x lemonbar')
    os.execute('pkill -x cat')
    os.execute('pkill conky')
    os.execute('pkill herbstclient')
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
