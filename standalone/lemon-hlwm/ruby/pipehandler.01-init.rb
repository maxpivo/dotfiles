require_relative 'output'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

def content_init(monitor, lemon_stdin)
  # initialize statusbar before loop
  set_tag_value(monitor)
  set_windowtitle('')
      
  text = get_statusbar_text(monitor)
  lemon_stdin.puts(text)
end

def run_lemon(monitor, parameters)
  command_out  = 'lemonbar ' + parameters + ' -p'

  IO.popen(command_out, 'w') do |io_lemon|  
    content_init(monitor, io_lemon)        
    io_lemon.close()
  end
end

def detach_lemon(monitor, parameters)
  # warning: Signal.trap is application wide
  Signal.trap("PIPE", "EXIT")
    
  pid = fork { run_lemon(monitor, parameters) }
  Process.detach(pid)
end
