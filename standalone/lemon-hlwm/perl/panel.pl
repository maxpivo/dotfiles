#!/usr/bin/perl
# This is a modularized config for herbstluftwm tags in lemonbar

use warnings;
use strict;

use File::Basename;
use lib dirname(__FILE__);

use helper;
use pipehandler;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

my $panel_height = 24;
my $monitor = helper::get_monitor(@ARGV);

system('pkill lemonbar');
system("herbstclient pad $monitor $panel_height 0 $panel_height 0");

# run process in the background

my $params_top = helper::get_params_top($monitor, $panel_height);
pipehandler::detach_lemon($monitor, $params_top);

my $params_bottom = helper::get_params_bottom($monitor, $panel_height);
pipehandler::detach_lemon_conky($params_bottom);
