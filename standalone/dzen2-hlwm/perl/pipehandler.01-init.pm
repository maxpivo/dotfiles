package pipehandler;

use warnings;
use strict;

use IO::Pipe;

use File::Basename;
use lib dirname(__FILE__);

use output;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# pipe

sub content_init {
    my $monitor = shift;
    my $pipe_dzen2_out = shift;

    output::set_tag_value($monitor);
    output::set_windowtitle('');

    my $text = output::get_statusbar_text($monitor);
    print $pipe_dzen2_out $text."\n";
    flush $pipe_dzen2_out;
}

sub run_dzen2 { 
    my $monitor = shift;
    my $parameters = shift;
    
    my $pipe_dzen2_out = IO::Pipe->new();
    my $command = "dzen2 $parameters -p";
    my $handle = $pipe_dzen2_out->writer($command);

    content_init     ($monitor, $pipe_dzen2_out);
    $pipe_dzen2_out->close();
}

sub detach_dzen2 { 
    my $monitor = shift;
    my $parameters = shift;

    my $pid = fork;
    return if $pid;     # in the parent process
    
    run_dzen2($monitor, $parameters);
    exit; 
}

sub detach_transset { 
    my $pid = fork;
    return if $pid;     # in the parent process
    
    sleep 1;
    system('transset .8 -n dzentop >/dev/null');
    
    exit; 
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
