#!/usr/bin/perl
# This is a modularized config for herbstluftwm tags in lemonbar

use warnings;
use strict;

use File::Basename;
use lib dirname(__FILE__);

use helper;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

my $panel_height = 24;
my $monitor = helper::get_monitor(@ARGV);

my $lemon_parameters = helper::get_lemon_parameters(
    $monitor, $panel_height);

print $lemon_parameters."\n";
