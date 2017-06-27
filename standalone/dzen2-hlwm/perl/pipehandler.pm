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
    my $event   = shift;
    
    # find out event origin
    my @column = split(/\t/, $event);
    my $origin = $column[0];

    if ($origin eq 'reload') {
        system('pkill dzen2');
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
    } elsif ($origin eq 'interval') {
        output::set_datetime();
    }    
}

sub content_init {
    my $monitor = shift;
    my $pipe_dzen2_out = shift;

    # initialize statusbar before loop
    output::set_tag_value($monitor);
    output::set_windowtitle('');
    output::set_datetime();

    my $text = output::get_statusbar_text($monitor);
    print $pipe_dzen2_out $text."\n";
    flush $pipe_dzen2_out;
}

sub content_event_idle {
    my $pipe_cat_out = shift;

    my $pid = fork;
    return if $pid;     # in the parent process

    # start a pipe
    my $pipe_idle_in = IO::Pipe->new();
    my $command = 'herbstclient --idle';
    my $handle  = $pipe_idle_in->reader($command);

    # wait for each event
    my $event = '';
    while ($event = <$pipe_idle_in>) {
        print $pipe_cat_out $event;
        flush $pipe_cat_out;
    }

    $pipe_idle_in->close();
}

sub content_event_interval {
    my $pipe_cat_out = shift;

    my $pid = fork;
    return if $pid;     # in the parent process
    
    while(1) {         
        print $pipe_cat_out "interval\n";
        flush $pipe_cat_out;
        
        sleep 1;
    }
}

sub content_walk {
    my $monitor = shift;
    my $pipe_dzen2_out = shift; 

    my ($rh_cat, $wh_cat);
    my $pid_cat = open2 ($rh_cat, $wh_cat, 'cat') 
        or die "can't pipe sh: $!";

    content_event_idle($wh_cat);
    content_event_interval($wh_cat);

    my $text  = '';
    my $event = '';

    # wait for each event, trim newline
    while (chomp($event = <$rh_cat>)) {
        handle_command_event($monitor, $event);

        $text = output::get_statusbar_text($monitor);
        print $pipe_dzen2_out $text."\n";
        flush $pipe_dzen2_out;
    }

    waitpid( $pid_cat, 0 );
}

sub run_dzen2 { 
    my $monitor = shift;
    my $parameters = shift;
    
    my $pipe_dzen2_out = IO::Pipe->new();
    my $command = "dzen2 $parameters";
    my $handle = $pipe_dzen2_out->writer($command);

    content_init     ($monitor, $pipe_dzen2_out);
    content_walk     ($monitor, $pipe_dzen2_out); # loop for each event
    $pipe_dzen2_out->close();
}

sub detach_dzen2 { 
    my $monitor = shift;
    my $parameters = shift;

    my $pid_dzen2 = fork;
    return if $pid_dzen2;     # in the parent process
    
    run_dzen2($monitor, $parameters);
    exit; 
}

sub detach_transset { 
    my $pid_transset = fork;
    return if $pid_transset;     # in the parent process
    
    sleep 1;
    system('transset .8 -n dzentop >/dev/null');
    
    exit; 
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
