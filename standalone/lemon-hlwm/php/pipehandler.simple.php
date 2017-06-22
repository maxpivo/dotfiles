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

function init_content($monitor, $lemon_stdin)
{   
    // initialize statusbar before loop
    set_tag_value($monitor);
    set_windowtitle('');
        
    $text = get_statusbar_text($monitor);
    fwrite($lemon_stdin, $text."\n");
    flush();
}

function walk_content($monitor, $lemon_stdin)
{       
    // start a pipe
    $descriptorspec = array(
        0 => array('pipe', 'r'),  // stdin
        1 => array('pipe', 'w'),  // stdout
        2 => array('pipe', 'w',)  // stderr
    );

    $command_in = 'herbstclient --idle';
    $proc_in  = proc_open($command_in,  $descriptorspec, $pipe_in);
    
    
    while(!feof($pipe_in[1])) {
        # read next event
        $event = fgets($pipe_in[1]);
        handle_command_event($monitor, $event);
        
        $text = get_statusbar_text($monitor);
        fwrite($lemon_stdin, $text."\n");
        flush();
    }
    
    pclose($pipe_in);
}

function run_lemon($monitor, $parameters) 
{ 
    $descriptorspec = array(
        0 => array('pipe', 'r'),  // stdin
        1 => array('pipe', 'w'),  // stdout
        2 => array('pipe', 'w',)  // stderr
    );
    
    $command_out  = "lemonbar $parameters";
    $proc_out = proc_open($command_out, $descriptorspec, $pipe_lemon);
    
    init_content($monitor, $pipe_lemon[0]);
    walk_content($monitor, $pipe_lemon[0]); // loop for each event

    pclose($pipe_lemon);
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
