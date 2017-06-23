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
        system('pkill dzen2');
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

function content_init($monitor, $pipe_dzen2_out)
{   
    // initialize statusbar before loop
    set_tag_value($monitor);
    set_windowtitle('');
        
    $text = get_statusbar_text($monitor);
    fwrite($pipe_dzen2_out, $text."\n");
    flush();
}

function content_walk($monitor, $pipe_dzen2_out)
{       
    // start a pipe
    $command_in    = 'herbstclient --idle';
    $pipe_idle_in  = popen($command_in,  'r'); // handle
    
    while(!feof($pipe_idle_in)) {
        # read next event
        $event = fgets($pipe_idle_in);
        handle_command_event($monitor, $event);
        
        $text = get_statusbar_text($monitor);
        fwrite($pipe_dzen2_out, $text);
        flush();
    }
    
    pclose($pipe_in);
}

function run_dzen2($monitor, $parameters) 
{ 
    $command_out    = "dzen2 $parameters";
    $pipe_dzen2_out = popen($command_out, 'w');

    content_init($monitor, $pipe_dzen2_out);
    content_walk($monitor, $pipe_dzen2_out); // loop for each event

    pclose($pipe_dzen2_out);
}

function detach_dzen2($monitor, $parameters)
{ 
    $pid = pcntl_fork();
    
    switch($pid) {         
    case -1 : // fork errror         
        die('could not fork');
    case 0  : // we are the child
        run_dzen2($monitor, $parameters); 
        break;
    default : // we are the parent             
        return $pid;
    }    
}

function detach_transset() 
{ 
    $pid = pcntl_fork();
    if ($pid == 0) { 
        sleep(1);
        system('transset .8 -n dzentop >/dev/null');
    }
}
