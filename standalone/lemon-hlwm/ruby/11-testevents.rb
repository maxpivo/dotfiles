#!/usr/bin/ruby


def content_event_idle(cat_stdin)
  pid = fork do 
    # start an io
    command_in = 'herbstclient --idle'
  
    IO.popen(command_in, "r") do |io_idle|
      while io_idle do 
         # read next event
        event = io_idle.gets
        cat_stdin.print(event)
      end
      io_idle.close()
    end
  end

  Process.detach(pid)  
end


def content_event_interval(cat_stdin)
  pid = fork do 
    timeformat = '%H:%M:%S'

    while true do
      localtime = Time.now
      time_str = localtime.strftime(timeformat)
      time_text = "interval\t#{time_str}\n";
      cat_stdin.print time_text

      sleep(3)
    end
  end

  Process.detach(pid)  
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# warning: Signal.trap is application wide
Signal.trap("PIPE", "EXIT")

# note the r+ mode for bidirectional
IO.popen('cat', 'r+') do |io_cat| 

  content_event_idle(io_cat)
  content_event_interval(io_cat)

    while io_cat do 
      # read next event
      event = (io_cat.gets).strip
      puts("event:\t[#{event}]")
    end
  
  io_cat.close()
end
