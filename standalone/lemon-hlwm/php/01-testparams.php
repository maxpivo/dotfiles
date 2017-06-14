#!/usr/bin/php 
<?php # using PHP7
# This is a modularized config for herbstluftwm tags in lemonbar

require_once(__DIR__.'/helper.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

$panel_height = 24;
$monitor = get_monitor($argv);

$lemon_parameters = get_lemon_parameters($monitor, $panel_height);
echo $lemon_parameters."\n";
