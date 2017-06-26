require_relative 'output'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

def content_init(monitor, dzen2_stdin)
  set_tag_value(monitor)
  set_windowtitle('')
      
  text = get_statusbar_text(monitor)
  dzen2_stdin.puts(text)
end

def run_dzen2(monitor, parameters)
  command_out  = 'dzen2 ' + parameters + ' -p'
  IO.popen(command_out, "w") do |io_dzen2| 
    content_init(monitor, io_dzen2)        
    io_dzen2.close()    
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
    system('transset .8 -n dzentop >/dev/null')        
  end
    
  Process.detach(pid)
end
