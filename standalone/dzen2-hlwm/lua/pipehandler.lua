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
    origin = column[0]

    tag_cmds = {'tag_changed', 'tag_flags', 'tag_added', 'tag_removed'}
    title_cmds = {'window_title_changed', 'focus_changed'}

    if origin == 'reload' then
        os.execute('pkill dzen2')
    elseif origin == 'quit_panel' then
        os.exit()
    elseif common.has_value(tag_cmds, origin) then
        output.set_tag_value(monitor)
    elseif common.has_value(title_cmds, origin) then
        output.set_windowtitle(column[2])
    end
end

function _M.init_content(monitor, process)
    -- initialize statusbar before loop
    output.set_tag_value(monitor)
    output.set_windowtitle('')

    local text = output.get_statusbar_text(monitor)
    process:write(text .. "\n")
    process:flush()
end

function _M.walk_content(monitor, process)    
    -- start a pipe
    command_in = 'herbstclient --idle'
    local pipe_in  = assert(io.popen(command_in,  'r'))
    local text = ''
  
    -- wait for each event 
    for event in pipe_in:lines() do
        _M.handle_command_event(monitor, event)    
    
        text = output.get_statusbar_text(monitor)
        process:write(text .. "\n")
        process:flush()
    end -- for loop
   
    pipein:close()
end

function _M.run_dzen2(monitor, parameters) 
    local command_out  = 'dzen2 ' .. parameters
    local pipe_out = assert(io.popen(command_out, 'w'))
    
    _M.init_content(monitor, pipe_out)
    _M.walk_content(monitor, pipe_out) -- loop for each event
        
    pipe_out:close()
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
        
        -- you may use either xorg-transset or transset-df instead
        -- https://github.com/wilfunctionyr/transset-df 
        os.execute('transset .8 -n dzentop >/dev/null') 
    else             -- this is the parent process
        -- nothing
    end
end


-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- return

return _M
