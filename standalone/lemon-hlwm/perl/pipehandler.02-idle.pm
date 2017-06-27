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

sub handle_command_event {
    my $monitor = shift;
    my $event = shift;
    
    # find out event origin
    my @column = split(/\t/, $event);
    my $origin = $column[0];

    if ($origin eq 'reload') {
        system('pkill lemonbar');
    } elsif ($origin eq 'quit_panel') {
        exit;
    } elsif (  # avoiding the unstable ~~ smartmatch operator
               ($origin eq 'tag_changed') 
            or ($origin eq 'tag_flags')
            or ($origin eq 'tag_added')
            or ($origin eq 'tag_removed')
            ) {
        output::set_tag_value($monitor);
    } elsif (  ($origin eq 'window_title_changed') 
            or ($origin eq 'focus_changed')
            ) {
        my $title = ($#column > 2) ? $column[2] : '';
        output::set_windowtitle($title);
    }    
}

sub content_init {
    my $monitor = shift;
    my $pipe_lemon_out = shift;

    # initialize statusbar before loop
    output::set_tag_value($monitor);
    output::set_windowtitle('');

    my $text = output::get_statusbar_text($monitor);
    print $pipe_lemon_out $text."\n";
    flush $pipe_lemon_out;
}

sub content_walk {
    my $monitor = shift;
    my $pipe_lemon_out = shift; 
    
    # start a pipe
    my $pipe_idle_in = IO::Pipe->new();
    my $command = 'herbstclient --idle';
    my $handle  = $pipe_idle_in->reader($command);

    my $text = '';
    my $event = '';

    # wait for each event, trim newline
    while (chomp($event = <$pipe_idle_in>)) {
        handle_command_event($monitor, $event);
        
        $text = output::get_statusbar_text($monitor);     
        print $pipe_lemon_out $text."\n";
        flush $pipe_lemon_out;
    }
    
    $pipe_idle_in->close();
}

sub run_lemon { 
    my $monitor = shift;
    my $parameters = shift;

    my $command_out = "lemonbar $parameters";
    my ($rh_lemon_out, $wh_lemon_out);
    my $pid_lemon_out = open2 (
            $rh_lemon_out, $wh_lemon_out, $command_out) 
        or die "can't pipe lemon out: $!";

    content_init($monitor, $wh_lemon_out);
    content_walk($monitor, $wh_lemon_out); # loop for each event

    waitpid( $pid_lemon_out, 0 );
}

sub detach_lemon { 
    my $monitor = shift;
    my $parameters = shift;

    my $pid_lemon = fork;
    return if $pid_lemon;     # in the parent process
    
    run_lemon($monitor, $parameters);
    exit; 
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
