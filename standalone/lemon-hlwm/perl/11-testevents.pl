#!/usr/bin/perl

use warnings;
use strict;

use IO::Pipe;
use IPC::Open2;
use Time::Piece;

sub content_event_idle {
    my $cat_out = shift;
    
    my $pid = fork;
    return if $pid;     # in the parent process
    
    # start a pipe
    my $idle_in  = IO::Pipe->new();
    my $command = 'herbstclient --idle';
    my $handle  = $idle_in->reader($command);

    my $text = '';
    my $event = '';

    while($event = <$idle_in>) {
        print $cat_out $event;
        flush $cat_out;
    }
    
    $idle_in->close();
}

sub content_event_interval {
    my $cat_out = shift;

    my $pid = fork;
    return if $pid;     # in the parent process

    my $time_format = '%H:%M:%S';
    my $time_text = '';
    my $time_str = '';
    
    while(1) {
        $time_str  = localtime->strftime($time_format);   
        $time_text = "interval\t$time_str\n";
        
        print $cat_out $time_text;
        flush $cat_out;
        
        sleep 3;
    }
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

my $event  = '';

my ($rh_cat, $wh_cat);
my $pid_cat = open2 ($rh_cat, $wh_cat, 'cat') 
    or die "can't pipe sh: $!";


content_event_idle($wh_cat);
content_event_interval($wh_cat);

while (chomp($event = <$rh_cat>)) {
    print "event:\t[$event]\n";    
    flush STDOUT;
}

waitpid( $pid_cat, 0 );
