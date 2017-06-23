<?php # using PHP7

require_once(__DIR__.'/output.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

function handle_command_event($monitor, $event)
{
    // find out event origin
    $column = explode("\t", $event);
    $origin = $column[0];

    switch($origin) {
    case 'reload':
        system('pkill lemonbar');
        break;
    case 'quit_panel':
        exit(1);
    case 'tag_changed':
    case 'tag_flags':
    case 'tag_added':
    case 'tag_removed':
        set_tag_value($monitor);
        break;
    case 'window_title_changed':
    case 'focus_changed':
        set_windowtitle($column[2]);
        break;
    }
}

function content_init($monitor, $pipe_lemon_stdin)
{   
    // initialize statusbar before loop
    set_tag_value($monitor);
    set_windowtitle('');
        
    $text = get_statusbar_text($monitor);
    fwrite($pipe_lemon_stdin, $text."\n");
    flush();
}

function content_walk($monitor, $pipe_lemon_stdin)
{       
    // start a pipe
    $command_in    = 'herbstclient --idle';
    $pipe_idle_in  = popen($command_in,  'r'); // handle
    
    while(!feof($pipe_idle_in)) {
        # read next event
        $event = fgets($pipe_idle_in);
        handle_command_event($monitor, $event);
        
        $text = get_statusbar_text($monitor);
        fwrite($pipe_lemon_stdin, $text."\n");
        flush();
    }
    
    pclose($pipe_idle_in);
}

function run_lemon($monitor, $parameters) 
{ 
    $descriptorspec = array(
        0 => array('pipe', 'r'),  // stdin
        1 => array('pipe', 'w'),  // stdout
        2 => array('pipe', 'w',)  // stderr
    );
    
    $command_out  = "lemonbar $parameters";
    $proc_lemon = proc_open($command_out, $descriptorspec, $pipe_lemon);
    $proc_sh    = proc_open('sh', $descriptorspec, $pipe_sh);
    
    $pid = pcntl_fork();
    
    switch($pid) {         
    case -1 : // fork errror         
        die('could not fork');
    case 0  : // we are the child
        content_init($monitor, $pipe_lemon[0]);
        content_walk($monitor, $pipe_lemon[0]); // loop for each event
        break;
    default : // we are the parent
        while(!feof($pipe_lemon[1])) {
            $buffer = fgets($pipe_lemon[1]);
            fwrite($pipe_sh[0], $buffer);
        }
        return $pid;
    } 

    pclose($pipe_lemon[0]);
}

function detach_lemon($monitor, $parameters)
{ 
    $pid = pcntl_fork();
    
    switch($pid) {         
    case -1 : // fork errror         
        die('could not fork');
    case 0  : // we are the child
        run_lemon($monitor, $parameters); 
        break;
    default : // we are the parent             
        return $pid;
    }    
}
