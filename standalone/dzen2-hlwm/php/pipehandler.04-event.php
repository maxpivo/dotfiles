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
    case 'interval':
        set_datetime();
    }
}

function content_init($monitor, $pipe_dzen2_out)
{   
    // initialize statusbar before loop
    set_tag_value($monitor);
    set_windowtitle('');
    set_datetime();
        
    $text = get_statusbar_text($monitor);
    fwrite($pipe_dzen2_out, $text."\n");
    flush();
}

function content_event_idle($pipe_cat_stdin) 
{
    $pid = pcntl_fork();

    switch($pid) {         
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
        return $pid;
    } 
}

function content_event_interval($pipe_cat_stdin) 
{
    date_default_timezone_set("Asia/Jakarta");
    $pid = pcntl_fork();

    switch($pid) {         
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
        return $pid;
    } 
}

function content_walk($monitor, $pipe_dzen2_stdin)
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
        fwrite($pipe_dzen2_stdin, $text."\n");
        flush();
    }

    pclose($pipe_cat[1]);
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
    $pid_dzen2 = pcntl_fork();
    
    switch($pid_dzen2) {         
    case -1 : // fork errror         
        die('could not fork');
    case 0  : // we are the child
        run_dzen2($monitor, $parameters); 
        break;
    default : // we are the parent             
        return $pid_dzen2;
    }    
}

function detach_transset() 
{ 
    $pid_transset = pcntl_fork();
    if ($pid_transset == 0) { 
        sleep(1);
        system('transset .8 -n dzentop >/dev/null');
    }
}
