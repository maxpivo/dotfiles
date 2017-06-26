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
        output::set_windowtitle($column[2]);
    }    
}

sub content_init {
    my $monitor = shift;
    my $pipe_dzen2_out = shift;

    # initialize statusbar before loop
    output::set_tag_value($monitor);
    output::set_windowtitle('');

    my $text = output::get_statusbar_text($monitor);
    print $pipe_dzen2_out $text."\n";
    flush $pipe_dzen2_out;
}

sub content_walk {
    my $monitor = shift;
    my $pipe_dzen2_out = shift; 
    
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
        print $pipe_dzen2_out $text;
        flush $pipe_dzen2_out;
    }
    
    $pipe_idle_in->close();
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
