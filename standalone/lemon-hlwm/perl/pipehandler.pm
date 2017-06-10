package pipehandler;

use warnings;
use strict;

use IO::Pipe;

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
    my $pipe_out = shift;
    
    # start a pipe
    my $pipe_in  = IO::Pipe->new();
    my $command = 'herbstclient --idle';
    my $handle  = $pipe_in->reader($command);

    my $text = '';
    my $event = '';

    while(<$pipe_in>) {
        # wait for next event
        $event = $_;        
        handle_command_event($monitor, $event);
        
        $text = output::get_statusbar_text($monitor);     
        print $pipe_out $text."\n";
        flush $pipe_out;
    }
    
    $pipe_in->close();
}

sub run_lemon { 
    my $monitor = shift;
    my $parameters = shift;

    my $pipe_out = IO::Pipe->new();
    my $command = "lemonbar $parameters";
    my $handle = $pipe_out->writer($command);

    init_content($monitor, $pipe_out);
    walk_content($monitor, $pipe_out); # loop for each event
    $pipe_out->close();
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
