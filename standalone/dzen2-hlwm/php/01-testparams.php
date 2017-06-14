#!/usr/bin/php 
<?php # using PHP7
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

require_once(__DIR__.'/helper.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

$panel_height = 24;
$monitor = get_monitor($argv);

$dzen2_parameters = get_dzen2_parameters($monitor, $panel_height);
echo "$dzen2_parameters\n";
