#!/usr/bin/perl
# This is a modularized config for herbstluftwm tags in lemonbar

use warnings;
use strict;

use File::Basename;
use lib dirname(__FILE__);

use helper;
use pipehandler;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

my $panel_height = 24;
my $monitor = helper::get_monitor(@ARGV);

# do `man herbsluftclient`, and type \pad to search what it means
#system("herbstclient pad $monitor $panel_height 0 $panel_height 0");

my $lemon_parameters = helper::get_lemon_parameters($monitor, $panel_height);

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

# remove all lemonbar instance
system('pkill lemonbar');

# run process in the background
pipehandler::detach_lemon($monitor, $lemon_parameters);
