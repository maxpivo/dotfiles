<?php # using PHP7

require_once(__DIR__.'/output.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

function content_init($monitor, $pipe_dzen2_out)
{   
    set_tag_value($monitor);
    set_windowtitle('');
        
    $text = get_statusbar_text($monitor);
    fwrite($pipe_dzen2_out, $text."\n");
    flush();
}

function run_dzen2($monitor, $parameters) 
{ 
    $command_out    = "dzen2 $parameters -p";
    $pipe_dzen2_out = popen($command_out, 'w');

    content_init($monitor, $pipe_dzen2_out);
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
