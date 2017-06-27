require_relative 'output'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

def handle_command_event(monitor, event) 
  # find out event origin
  column = event.split("\t")
  origin = column[0]
    
  tag_cmds = ['tag_changed', 'tag_flags', 'tag_added', 'tag_removed']
  title_cmds = ['window_title_changed', 'focus_changed']

  case origin
  when 'reload'
    os.system('pkill lemonbar')
  when 'quit_panel'
    exit
  when *tag_cmds       # splat operator
    set_tag_value(monitor)
  when *title_cmds     # splat operator
    title = column.length > 2 ? column[2] : ''
    set_windowtitle(title)
  when 'interval'
    set_datetime()
  end
end

def content_init(monitor, lemon_stdin)
  # initialize statusbar before loop
  set_tag_value(monitor)
  set_windowtitle('')
  set_datetime()
      
  text = get_statusbar_text(monitor)
  lemon_stdin.puts(text)
end

def content_event_idle(cat_stdin)
  pid_idle = fork do 
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

  Process.detach(pid_idle)  
end

def content_event_interval(cat_stdin)
  pid_interval = fork do 
    while true do
      cat_stdin.print "interval\n"
      sleep(1)
    end
  end

  Process.detach(pid_interval)  
end

def content_walk(monitor, lemon_stdin)
  # note the r+ mode for bidirectional
  IO.popen('cat', 'r+') do |io_cat| 

    content_event_idle(io_cat)
    content_event_interval(io_cat)

    while io_cat do 
      # read next event, trim newline
      event = (io_cat.gets).strip
      handle_command_event(monitor, event)
        
      text = get_statusbar_text(monitor)
      lemon_stdin.puts(text)
    end
  
  io_cat.close()
  end
end

def run_lemon(monitor, parameters)
  command_out  = 'lemonbar ' + parameters

  # note the r+ mode
  IO.popen(command_out, 'r+') do |io_lemon| 

    pid_content = fork do 
      content_init(monitor, io_lemon)
      content_walk(monitor, io_lemon) # loop for each event
      
      io_lemon.close()
    end
    Process.detach(pid_content)

    # CPU hog caveat when using 'pkill lemonbar'
    # Abnormal lemonbar process termination, will make this loop go wild

    IO.popen('sh', 'w') do |io_sh|
      while io_lemon do
        io_sh.puts io_lemon.gets
      end
        
      io_sh.close()
    end
 
    io_lemon.close()
  end
end

def detach_lemon(monitor, parameters)
  # warning: Signal.trap is application wide
  Signal.trap("PIPE", "EXIT")
    
  pid_lemon = fork { run_lemon(monitor, parameters) }
  Process.detach(pid_lemon)
end
