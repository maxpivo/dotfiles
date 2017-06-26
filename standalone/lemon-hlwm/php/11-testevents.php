#!/usr/bin/php
<?php # using PHP7

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
        $timeformat = '%H:%M:%S';

        do {
            $time_str = strftime($timeformat);
            $time_text = "interval\t${time_str}\n";
            fwrite($pipe_cat_stdin, $time_text);
            flush();
            sleep(3);
        } while (true);
        
        break;
    default : // we are the parent
        // do nothing
        return $pid;
    } 
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

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
    echo("$event\n");

    # uncomment to examine more complete behaviour
    # echo("tab:\t[${event}]\n");
}

pclose($pipe_cat[1]);
