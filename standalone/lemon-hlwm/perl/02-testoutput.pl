#!/usr/bin/perl
# This is a modularized config for herbstluftwm tags in lemonbar

use warnings;
use strict;

use File::Basename;
use lib dirname(__FILE__);

use helper;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# process handler

sub test_lemon { 
    use IO::Pipe;
    use output;

    my $monitor = shift;
    my $parameters = shift;
    
    my $pipe_out = IO::Pipe->new();
    my $command = "lemonbar $parameters -p";
    my $handle = $pipe_out->writer($command);

    # initialize statusbar
    output::set_tag_value($monitor);
    output::set_windowtitle('test');

    my $text = output::get_statusbar_text($monitor);
    print $pipe_out $text."\n";
    flush $pipe_out;

    $pipe_out->close();
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

my $panel_height = 24;
my $monitor = helper::get_monitor(@ARGV);

# do `man herbsluftclient`, and type \pad to search what it means
system("herbstclient pad $monitor $panel_height 0 $panel_height 0");

my $lemon_parameters = helper::get_lemon_parameters(
    $monitor, $panel_height);

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# test

# run process
test_lemon($monitor, $lemon_parameters);
