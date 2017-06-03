#!/usr/bin/php 
<?php # using PHP7
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_once(__DIR__.'/helper.php');
require_once(__DIR__.'/pipehandler.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

$panel_height = 24;
$monitor = get_monitor($argv);

# do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad $monitor $panel_height 0 $panel_height 0");

$dzen2_parameters = get_dzen2_parameters($monitor, $panel_height);

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all dzen2 instance
system('pkill dzen2');

# run process in the background
detach_dzen2($monitor, $dzen2_parameters);

# optional transparency
detach_transset();
