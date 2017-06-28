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
    } elsif ($origin eq 'interval') {
        output::set_datetime();
    }   
}

sub content_init {
    my $monitor = shift;
    my $pipe_lemon_out = shift;

    # initialize statusbar before loop
    output::set_tag_value($monitor);
    output::set_windowtitle('');
    output::set_datetime();

    my $text = output::get_statusbar_text($monitor);
    print $pipe_lemon_out $text."\n";
    flush $pipe_lemon_out;
}

sub content_event_idle {
    my $pipe_cat_out = shift;
 
    my $pid_idle = fork;
    return if $pid_idle;     # in the parent process

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

    my $pid_interval = fork;
    return if $pid_interval;     # in the parent process
    
    while(1) {         
        print $pipe_cat_out "interval\n";
        flush $pipe_cat_out;
        
        sleep 1;
    }
}

sub content_walk {
    my $monitor = shift;
    my $pipe_lemon_out = shift; 

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
        print $pipe_lemon_out $text."\n";
        flush $pipe_lemon_out;
    }

    waitpid( $pid_cat, 0 );
}

sub run_lemon { 
    my $monitor = shift;
    my $parameters = shift;

    my $command_out = "lemonbar $parameters";
    my ($rh_lemon_out, $wh_lemon_out);
    my $pid_lemon_out = open2 (
            $rh_lemon_out, $wh_lemon_out, $command_out) 
        or die "can't pipe lemon out: $!";
        
    my ($rh_sh, $wh_sh);
    my $pid_sh = open2 ($rh_sh, $wh_sh, 'sh') 
        or die "can't pipe sh: $!";

    my $pid_content = fork;
    if ($pid_content) {
        # in the parent process
        my $line_clickable = '';
        while($line_clickable = <$rh_lemon_out>) {
            print $wh_sh $line_clickable;
            flush $wh_sh;
        }        
    } else {
        # in the child process
        content_init($monitor, $wh_lemon_out);
        content_walk($monitor, $wh_lemon_out); # loop for each event
    }

    waitpid( $pid_lemon_out, 0 );
    waitpid( $pid_sh, 0 );
}

sub detach_lemon { 
    my $monitor = shift;
    my $parameters = shift;

    my $pid_lemon = fork;
    return if $pid_lemon;     # in the parent process
    
    run_lemon($monitor, $parameters);
    exit; 
}

sub detach_lemon_conky { 
    my $parameters = shift;

    my $pid_conky = fork;
    return if $pid_conky;     # in the parent process

    my $pipe_out = IO::Pipe->new();
    my $cmd_in   = "lemonbar " . $parameters;
    my $hnd_in   = $pipe_out->writer($cmd_in);

    my $pipe_in  = IO::Pipe->new();
    my $dirname  = dirname(__FILE__);
    my $path     = "$dirname/../conky";       
    my $cmd_out  = "conky -c $path/conky.lua";
    my $hnd_out  = $pipe_in->reader($cmd_out);

    while(<$pipe_in>) {
        print $pipe_out $_;
        flush $pipe_out;
    }

    $pipe_in->close();
    $pipe_out->close();
    exit; 
}

sub kill_zombie() {
    system('pkill dzen2');
    system('pkill lemonbar');
    system('pkill cat');
    system('pkill conky');
    system('pkill herbstclient');
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
