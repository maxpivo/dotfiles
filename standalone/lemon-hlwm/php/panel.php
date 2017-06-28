#!/usr/bin/php 
<?php # using PHP7
# This is a modularized config for herbstluftwm tags in lemonbar

require_once(__DIR__.'/helper.php');
require_once(__DIR__.'/pipehandler.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

$panel_height = 24;
$monitor = get_monitor($argv);

kill_zombie();
system("herbstclient pad $monitor $panel_height 0 $panel_height 0");

// run process in the background

$params_top = get_params_top($monitor, $panel_height);
detach_lemon($monitor, $params_top);

$params_bottom = get_params_bottom($monitor, $panel_height);
detach_lemon_conky($params_bottom);
