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

use constant SEPARATOR => "^bg()^fg($color{'black'})|^bg()^fg()";

# http://fontawesome.io/
use constant FONT_AWESOME => "^fn(FontAwesome-9)";

# Powerline Symbol
use constant RIGHT_HARD_ARROW => "^fn(powerlinesymbols-14)^fn()";
use constant RIGHT_SOFT_ARROW => "^fn(powerlinesymbols-14)^fn()";
use constant LEFT_HARD_ARROW  => "^fn(powerlinesymbols-14)^fn()";
use constant LEFT_SOFT_ARROW  => "^fn(powerlinesymbols-14)^fn()";

# theme
use constant PRE_ICON  => "^fg($color{'yellow500'})".FONT_AWESOME;
use constant POST_ICON => "^fn()^fg()";

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

sub get_statusbar_text {
    my $monitor = shift;   
    my $text = '';

    # draw tags
    foreach my $tag_status (@tags_status) {
        $text .= output_by_tag($monitor, $tag_status);
    }

    # draw date and time   
    $text .= output_by_datetime();
    
    # draw window title    
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
        $text_pre = "^bg($color{'blue500'})^fg($color{'black'})"
                  . RIGHT_HARD_ARROW
                  . "^bg($color{'blue500'})^fg($color{'white'})";
    } elsif ($tag_mark eq '+') {
        $text_pre = "^bg($color{'yellow500'})^fg($color{'grey400'})";
    } elsif ($tag_mark eq ':') {
        $text_pre = "^bg()^fg($color{'white'})";
    } elsif ($tag_mark eq '!') {
        $text_pre = "^bg($color{'red500'})^fg($color{'white'})";
    } else {
        $text_pre = "^bg()^fg($color{'grey600'})";
    }
   
    # ----- tag by number
   
    # assuming using dzen2_svn
    # clickable tags if using SVN dzen
    my $text_name = "^ca(1,herbstclient focus_monitor \"$monitor\" && "
                  . "herbstclient use \"$tag_index\") $tag_name ^ca() ";
    
    # ----- post tag
    
    my $text_post = "";
    if ($tag_mark eq '#') {
        $text_post = "^bg($color{'black'})^fg($color{'blue500'})"
                   . RIGHT_HARD_ARROW;
    } 
     
    return $text_pre . $text_name . $text_post;
}

sub output_by_title {
    my $text = " ^r(5x0) ".SEPARATOR." ^r(5x0) ";
    $text   .= $segment_windowtitle;

    return $text;
}

sub output_by_datetime {
    my $text = " ^r(5x0) ".SEPARATOR." ^r(5x0) ";
    $text   .= $segment_datetime;

    return $text;
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
                         . "^bg()^fg($color{'grey700'}) $windowtitle";
}

sub set_datetime {
    my $date_icon = PRE_ICON."".POST_ICON;
    my $date_format = '%a %b %d';
    my $date_str = localtime->strftime($date_format);      
    my $date_text = "$date_icon ^bg()^fg($color{'grey700'}) $date_str";

    my $time_icon = PRE_ICON."".POST_ICON;
    my $time_format = '%H:%M:%S';
    my $time_str = localtime->strftime($time_format);
    my $time_text = "$time_icon ^bg()^fg($color{'blue500'}) $time_str";

    $segment_datetime = "$date_text  $time_text";
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
