#!/usr/bin/php 
<?php # using PHP7
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_once(__DIR__.'/helper.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

$panel_height = 24;
$monitor = get_monitor($argv);

// do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad $monitor $panel_height 0 $panel_height 0");

$dzen2_parameters = get_dzen2_parameters($monitor, $panel_height);
echo "$dzen2_parameters\n";
