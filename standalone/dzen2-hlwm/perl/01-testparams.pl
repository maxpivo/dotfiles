#!/usr/bin/perl
# This is a modularized config for herbstluftwm tags in dzen2 statusbar

use warnings;
use strict;

use File::Basename;
use lib dirname(__FILE__);

use helper;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

my $panel_height = 24;
my $monitor = helper::get_monitor(@ARGV);

my $dzen2_parameters = helper::get_dzen2_parameters(
    $monitor, $panel_height);

print $dzen2_parameters."\n";
