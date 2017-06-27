#!/usr/bin/lua
local posix = require "posix"

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- helper

-- because os.clock function will hogs your cpu
function os_sleep(n)
  os.execute('sleep ' .. tonumber(n))
end

-- http://lua-users.org/wiki/StringTrim
function trim1(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- event

function content_event_idle(pipe_cat_out)
    local pid = posix.fork()

    if pid == 0 then -- this is the child process
        -- start a pipe
        command_in = 'herbstclient --idle'
        local pipe_in  = assert(io.popen(command_in,  'r'))
  
        -- wait for each event 
        for event in pipe_in:lines() do
            posix.write(pipe_cat_out, event)
            io.flush()
        end -- for loop
   
        pipein:close()
    else             -- this is the parent process
        -- nothing
    end
end

function content_event_interval(pipe_cat_out) 
    local pid = posix.fork()

    if pid == 0 then -- this is the child process
        local timeformat = '%H:%M:%S'

        while true do
            local time_str  = os.date(timeformat)
            local time_text = 'interval' .. "\t" .. time_str
            
            posix.write(pipe_cat_out, time_text)
            io.flush() 

            os_sleep(3)
        end
    else             -- this is the parent process
        -- nothing
    end
end

-- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- -----
-- main

-- https://stackoverflow.com/questions/1242572/how-do-you-construct-a-read-write-pipe-with-lua

rd, wr = posix.pipe()

content_event_idle(wr)
content_event_interval(wr)

local bufsize = 4096
local event = ''

while true do
    event = trim1(posix.read(rd, bufsize))
    if event == nil or #event == 0 then break end
    
    print("event:\t[" .. event .."]")
end

posix.close(rd)
posix.close(wr)
