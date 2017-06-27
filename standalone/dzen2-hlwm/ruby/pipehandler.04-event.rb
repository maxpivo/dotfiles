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
    os.system('pkill dzen2')
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

def content_init(monitor, dzen2_stdin)
  # initialize statusbar before loop
  set_tag_value(monitor)
  set_windowtitle('')
  set_datetime()
      
  text = get_statusbar_text(monitor)
  dzen2_stdin.puts(text)
end

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
    while true do
      cat_stdin.print "interval\n"

      sleep(1)
    end
  end

  Process.detach(pid)  
end

def content_walk(monitor, dzen2_stdin)
  # note the r+ mode for bidirectional
  IO.popen('cat', 'r+') do |io_cat| 

    content_event_idle(io_cat)
    content_event_interval(io_cat)

    while io_cat do 
      # read next event, trim newline
      event = (io_cat.gets).strip
      handle_command_event(monitor, event)
        
      text = get_statusbar_text(monitor)
      dzen2_stdin.puts(text)
    end
  
  io_cat.close()
  end
end

def run_dzen2(monitor, parameters)
  command_out  = 'dzen2 ' + parameters
  IO.popen(command_out, "w") do |io_dzen2| 
    content_init(monitor, io_dzen2)
    content_walk(monitor, io_dzen2) # loop for each event
        
    io_dzen2.close()    
  end
end

def detach_dzen2(monitor, parameters)
  # warning: Signal.trap is application wide
  Signal.trap("PIPE", "EXIT")
    
  pid_dzen2 = fork { run_dzen2(monitor, parameters) }
  Process.detach(pid_dzen2)
end

def detach_transset()
  pid_transset = fork do
    sleep(1)
    system('transset .8 -n dzentop >/dev/null')        
  end
    
  Process.detach(pid_transset)
end
