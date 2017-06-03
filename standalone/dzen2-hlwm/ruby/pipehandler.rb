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
    set_windowtitle(column[2])
  end
end

def do_content(monitor, stdin)
  # initialize statusbar before loop
  set_tag_value(monitor)
  text = get_statusbar_text(monitor)
  stdin.puts(text)
    
  # start a pipe
  command_in = 'herbstclient --idle'
  event = '' 
  
  IO.popen(command_in, "r") do |f| 
    # wait for each event
    while f do 
      event = f.gets
      handle_command_event(monitor, event)
        
      text = get_statusbar_text(monitor)
      stdin.write(text)
    end
    f.close()    
  end
end

def run_dzen2(monitor, parameters)
  command_out  = 'dzen2 ' + parameters
  IO.popen(command_out, "w") do |f| 
    do_content(monitor, f)
        
    f.close()    
  end
end

def detach_dzen2(monitor, parameters)
  # warning: Signal.trap is application wide
  Signal.trap("PIPE", "EXIT")
    
  pid = fork { run_dzen2(monitor, parameters) }
  Process.detach(pid)
end

def detach_transset()
  pid = fork do
    sleep(1)

    # you may use either xorg-transset instead or transset-df
    # https://github.com/wildefyr/transset-df
    system('transset .8 -n dzentop >/dev/null')        
  end
    
  Process.detach(pid)
end
