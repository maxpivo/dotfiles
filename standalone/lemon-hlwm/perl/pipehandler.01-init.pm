package pipehandler;

use warnings;
use strict;

# for tutorial purpose, we use two libraries
use IO::Pipe;   # unidirectional
use IPC::Open2; #  bidirectional

use File::Basename;
use lib dirname(__FILE__);

use output;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

sub content_init {
    my $monitor = shift;
    my $pipe_lemon_out = shift;

    output::set_tag_value($monitor);
    output::set_windowtitle('');

    my $text = output::get_statusbar_text($monitor);
    print $pipe_lemon_out $text."\n";
    flush $pipe_lemon_out;
}

sub run_lemon { 
    my $monitor = shift;
    my $parameters = shift;

    my $command_out = "lemonbar $parameters -p";
    my ($rh_lemon_out, $wh_lemon_out);
    my $pid_lemon_out = open2 (
            $rh_lemon_out, $wh_lemon_out, $command_out) 
        or die "can't pipe lemon out: $!";

    content_init($monitor, $wh_lemon_out);
    waitpid( $pid_lemon_out, 0 );
}

sub detach_lemon { 
    my $monitor = shift;
    my $parameters = shift;

    my $pid = fork;
    return if $pid;     # in the parent process
    
    run_lemon($monitor, $parameters);
    exit; 
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
