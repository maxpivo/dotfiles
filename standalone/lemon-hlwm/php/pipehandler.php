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
        $title = count($column) > 2 ? $column[2] : '';
        set_windowtitle($title);
        break;
    case 'interval':
        set_datetime();
    }
}

function content_init($monitor, $pipe_lemon_stdin)
{   
    // initialize statusbar before loop
    set_tag_value($monitor);
    set_windowtitle('');
    set_datetime();

    $text = get_statusbar_text($monitor);
    fwrite($pipe_lemon_stdin, $text."\n");
    flush();
}

function content_event_idle($pipe_cat_stdin) 
{
    $pid_idle = pcntl_fork();

    switch($pid_idle) {         
    case -1 : // fork errror         
        die('could not fork');
    case 0  : // we are the child
        // start a pipe
        $command_in    = 'herbstclient --idle';
        $pipe_idle_in  = popen($command_in,  'r'); // handle
    
        while(!feof($pipe_idle_in)) {
            # read next event
            $event = fgets($pipe_idle_in);
            fwrite($pipe_cat_stdin, $event);
            flush();
        }
    
        pclose($pipe_idle_in);

        break;
    default : // we are the parent
        // do nothing
        return $pid_idle;
    } 
}

function content_event_interval($pipe_cat_stdin) 
{
    date_default_timezone_set("Asia/Jakarta");
    $pid_interval = pcntl_fork();

    switch($pid_interval) {         
    case -1 : // fork errror         
        die('could not fork');
    case 0  : // we are the child
        do {
            fwrite($pipe_cat_stdin, "interval\n");
            flush();
            sleep(1);
        } while (true);
        
        break;
    default : // we are the parent
        // do nothing
        return $pid_interval;
    } 
}

function content_walk($monitor, $pipe_lemon_stdin)
{       
    $descriptorspec = array(
        0 => array('pipe', 'r'),  // stdin
        1 => array('pipe', 'w'),  // stdout
        2 => array('pipe', 'w',)  // stderr
    );
    
    $proc_cat = proc_open('cat', $descriptorspec, $pipe_cat);

    content_event_idle($pipe_cat[0]);
    content_event_interval($pipe_cat[0]);

    while(!feof($pipe_cat[1])) {
        $event = trim(fgets($pipe_cat[1]));
        handle_command_event($monitor, $event);
        
        $text = get_statusbar_text($monitor);
        fwrite($pipe_lemon_stdin, $text."\n");
        flush();
    }

    pclose($pipe_cat[1]);
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
    
    $pid_content = pcntl_fork();
    
    switch($pid_content) {         
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
        return $pid_content;
    } 

    pclose($pipe_lemon[0]);
}

function detach_lemon($monitor, $parameters)
{ 
    $pid_lemon = pcntl_fork();
    
    switch($pid_lemon) {         
    case -1 : // fork errror         
        die('could not fork');
    case 0  : // we are the child
        run_lemon($monitor, $parameters); 
        break;
    default : // we are the parent             
        return $pid_lemon;
    }
}

function detach_lemon_conky($parameters)
{ 
    $pid_conky = pcntl_fork();

    switch($pid_conky) {         
    case -1 : // fork errror         
        die('could not fork');
    case 0  : // we are the child
        $cmd_out  = 'lemonbar '.$parameters;
        $pipe_out = popen($cmd_out, "w");

        $path     = __dir__."/../assets";
        $cmd_in   = 'conky -c '.$path.'/conky.lua';
        $pipe_in  = popen($cmd_in,  "r");
    
        while(!feof($pipe_in)) {
            $buffer = fgets($pipe_in);
            fwrite($pipe_out, $buffer);
            flush();
        }
    
        pclose($pipe_in);
        pclose($pipe_out);

        break;
    default : // we are the parent             
        return $pid_conky;
    }  
}
