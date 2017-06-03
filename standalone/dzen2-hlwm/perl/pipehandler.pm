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

sub do_content {
    my $monitor = shift;
    my $pipe_out = shift;     
    
    # initialize statusbar before loop
    output::set_tag_value($monitor);
    my $text = output::get_statusbar_text($monitor);
    print $pipe_out $text."\n";
    flush $pipe_out;

    # start a pipe
    my $pipe_in  = IO::Pipe->new();
    my $command = 'herbstclient --idle';
    my $handle  = $pipe_in->reader($command);

    my $event = '';    
    while(<$pipe_in>) {
        # wait for next event
        $event = $_;        
        handle_command_event($monitor, $event);
        
        $text = output::get_statusbar_text($monitor);     
        print $pipe_out $text;
        flush $pipe_out;
    }
    
    $pipe_in->close();
}

sub run_dzen2 { 
    my $monitor = shift;
    my $parameters = shift;
    
    my $pipe_out = IO::Pipe->new();
    my $command = "dzen2 $parameters";
    my $handle = $pipe_out->writer($command);

    do_content($monitor, $pipe_out);
    $pipe_out->close();
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
    
    # you may use either xorg-transset instead or transset-df
    # https://github.com/wildefyr/transset-df
    system('transset .8 -n dzentop >/dev/null');
    
    exit; 
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
