package output;

use warnings;
use strict;

use Time::Piece;

use File::Basename;
use lib dirname(__FILE__);

use gmc;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# assuming $ herbstclient tag_status
# 	#1	:2	:3	:4	.5	.6	.7	.8	.9

# custom tag names
use constant TAG_SHOWS => ['一 ichi', '二 ni', '三 san', '四 shi', 
    '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū'];

# initialize variable segment
my $segment_windowtitle = ''; # empty string
my @tags_status         = []; # empty array
my $segment_datetime    = ''; # empty string

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

use constant SEPARATOR => "%{B-}%{F$color{'yellow500'}}|%{B-}%{F-}";

# Powerline Symbol
use constant RIGHT_HARD_ARROW => "";
use constant RIGHT_SOFT_ARROW => "";
use constant LEFT_HARD_ARROW  => "";
use constant LEFT_SOFT_ARROW  => "";

# theme
use constant PRE_ICON  => "%{F$color{'yellow500'}}";
use constant POST_ICON => "%{F-}";

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

sub get_statusbar_text {
    my $monitor = shift;   
    my $text = '';

    # draw tags
    $text .= '%{l}';
    foreach my $tag_status (@tags_status) {
        $text .= output_by_tag($monitor, $tag_status);
    }

    # draw date and time
    $text .= '%{c}';
    $text .= output_by_datetime();
    
    # draw window title
    $text .= '%{r}';
    $text .= output_by_title();
    
    return $text;
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

sub output_by_tag {
    my $monitor = shift;    
    
    my $tag_status = shift;
    my $tag_index  = substr($tag_status, 1, 1);
    my $tag_mark   = substr($tag_status, 0, 1);
    my $tag_name   = TAG_SHOWS->[$tag_index - 1]; # zero based

    # ----- pre tag

    my $text_pre = '';
    if ($tag_mark eq '#') {
        $text_pre = "%{B$color{'blue500'}}%{F$color{'black'}}"
                  . "%{U$color{'white'}}%{+u}".RIGHT_HARD_ARROW
                  . "%{B$color{'blue500'}}%{F$color{'white'}}"
                  . "%{U$color{'white'}}%{+u}";
    } elsif ($tag_mark eq '+') {
        $text_pre = "%{B$color{'yellow500'}}%{F$color{'grey400'}}";
    } elsif ($tag_mark eq ':') {
        $text_pre = "%{B-}%{F$color{'white'}}"
                  . "%{U$color{'red500'}}%{+u}";
    } elsif ($tag_mark eq '!') {
        $text_pre = "%{B$color{'red500'}}%{F$color{'white'}}"
                  . "%{U$color{'white'}}%{+u}";
    } else {
        $text_pre = "%{B-}%{F$color{'grey600'}}%{-u}";
    }

    # ----- tag by number

    # clickable tags
    my $text_name = "%{A:herbstclient focus_monitor \"$monitor\" && "
                  . "herbstclient use \"$tag_index\":} $tag_name %{A} ";
                  
    # non clickable tags
    # my $text_name = " $tag_name ";

    # ----- post tag
    
    my $text_post = "";
    if ($tag_mark eq '#') {
        $text_post = "%{B-}%{F$color{'blue500'}}"
                   . "%{U$color{'red500'}}%{+u}"
                   . RIGHT_HARD_ARROW;
    }
    
    my $text_clear = '%{B-}%{F-}%{-u}';
     
    return $text_pre . $text_name . $text_post . $text_clear;
}

sub output_by_title {
    my $text = "$segment_windowtitle ".SEPARATOR."  ";
    return $text;
}

sub output_by_datetime {
    return $segment_datetime;
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

sub set_tag_value {
    my $monitor = shift;
    
    my $tag_status_qx = qx(herbstclient tag_status $monitor);
       $tag_status_qx =~ s/^\s+|\s+$//g;
    @tags_status = split(/\t/, $tag_status_qx);
}

sub set_windowtitle {
    my $windowtitle = shift;  
    my $icon = PRE_ICON."".POST_ICON;
      
    $segment_windowtitle = " $icon "
                         . "%{B-}%{F$color{'grey700'}} $windowtitle";
}

sub set_datetime {
    my $date_icon = PRE_ICON."".POST_ICON;
    my $date_format = '%a %b %d';
    my $date_str = localtime->strftime($date_format);
    my $date_text = "$date_icon %{B-}%{F$color{'grey700'}} $date_str";

    my $time_icon = PRE_ICON."".POST_ICON;
    my $time_format = '%H:%M:%S';
    my $time_str = localtime->strftime($time_format);
    my $time_text = "$time_icon %{B-}%{F$color{'blue500'}} $time_str";

    $segment_datetime = "$date_text  $time_text";
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
