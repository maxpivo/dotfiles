<?php # using PHP7

require_once(__DIR__.'/output.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

function content_init($monitor, $pipe_lemon_stdin)
{   
    set_tag_value($monitor);
    set_windowtitle('');
        
    $text = get_statusbar_text($monitor);
    fwrite($pipe_lemon_stdin, $text."\n");
    flush();
}

function run_lemon($monitor, $parameters) 
{ 
    $descriptorspec = array(
        0 => array('pipe', 'r'),  // stdin
        1 => array('pipe', 'w'),  // stdout
        2 => array('pipe', 'w',)  // stderr
    );
    
    $command_out = "lemonbar $parameters -p";
    $proc_lemon = proc_open($command_out, $descriptorspec, $pipe_lemon);
    
    content_init($monitor, $pipe_lemon[0]);
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
