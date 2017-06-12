#!/usr/bin/php 
<?php # using PHP7
# This is a modularized config for herbstluftwm tags in lemonbar

require_once(__DIR__.'/helper.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# process handler

require_once(__DIR__.'/output.php');

function test_lemon($monitor, $parameters) 
{
    $command_out  = "lemonbar $parameters -p";
    $pipe_out = popen($command_out, 'w');

    // initialize statusbar
    set_tag_value($monitor);
    set_windowtitle('test');
        
    $text = get_statusbar_text($monitor);
    fwrite($pipe_out, $text."\n");
    flush();

    pclose($pipe_out);
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

$panel_height = 24;
$monitor = get_monitor($argv);

// do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad $monitor $panel_height 0 $panel_height 0");

$lemon_parameters = get_lemon_parameters($monitor, $panel_height);

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

// run process
test_lemon($monitor, $lemon_parameters);

