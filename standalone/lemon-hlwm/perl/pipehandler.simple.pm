package pipehandler;

use warnings;
use strict;

use IPC::Open2;

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
        output::set_windowtitle($column[2]);
    }    
}

sub init_content {
    my $monitor = shift;
    my $pipe_out = shift;

    # initialize statusbar before loop
    output::set_tag_value($monitor);
    output::set_windowtitle('');

    my $text = output::get_statusbar_text($monitor);
    print $pipe_out $text."\n";
    flush $pipe_out;
}

sub walk_content {
    my $monitor = shift;
    my $wh_out = shift;
    
    # start a pipe
    my $command_in = 'herbstclient --idle';
    
    my ($rh_in, $wh_in);
    my $pid_in  = open2 ($rh_in,  $wh_in,  $command_in)
        or die "can't pipe in: $!";

    my $text = '';
    my $event = '';

    while($event = <$rh_in>) {
        # wait for next event
        handle_command_event($monitor, $event);
        
        $text = output::get_statusbar_text($monitor);     
        print $wh_out $text."\n";
        flush $wh_out;
    }
    
    waitpid( $pid_in,  0 );
}

sub run_lemon { 
    my $monitor = shift;
    my $parameters = shift;

    my $command_out = "lemonbar $parameters";
    my ($rh_out, $wh_out);
    my $pid_out = open2 ($rh_out, $wh_out, $command_out) 
        or die "can't pipe out: $!";

    init_content($monitor, $wh_out);
    walk_content($monitor, $wh_out); # loop for each event

     waitpid( $pid_out, 0 );
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
