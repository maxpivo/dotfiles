package output;

use warnings;
use strict;

use File::Basename;
use lib dirname(__FILE__);

use gmc;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# assuming $ herbstclient tag_status
# 	#1	:2	:3	:4	.5	.6	.7	.8	.9

# custom tag names
my @tag_shows = ('一 ichi', '二 ni', '三 san', '四 shi', 
    '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū');

# initialize variable segment
my $segment_windowtitle = '';
my @tags_status = [];

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

my $separator = "^bg()^fg($color{'black'})|^bg()^fg()";

# http://fontawesome.io/
my $font_awesome = "^fn(FontAwesome-9)";

# Powerline Symbol
my $right_hard_arrow = "^fn(powerlinesymbols-14)^fn()";
my $right_soft_arrow = "^fn(powerlinesymbols-14)^fn()";
my $left_hard_arrow  = "^fn(powerlinesymbols-14)^fn()";
my $left_soft_arrow  = "^fn(powerlinesymbols-14)^fn()";

# theme
my $pre_icon    = "^fg($color{'yellow500'})$font_awesome";
my $post_icon   = "^fn()^fg()";

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

sub get_statusbar_text {
    my $monitor = shift;   
    my $text = '';

    # draw tags
    foreach my $tag_status (@tags_status) {
        $text .= output_by_tag($monitor, $tag_status);
    }
    
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
    my $tag_name   = $tag_shows[$tag_index - 1]; # zero based

    # ----- pre tag

    my $text_pre = '';
    if ($tag_mark eq '#') {
        $text_pre = "^bg($color{'blue500'})^fg($color{'black'})"
                  . $right_hard_arrow
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
                      . $right_hard_arrow;
    } 
     
    return $text_pre . $text_name . $text_post;
}

sub output_by_title {
    my $text = " ^r(5x0) $separator ^r(5x0) ";
    $text   .= $segment_windowtitle;

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
    my $icon = "$pre_icon$post_icon";
      
    $segment_windowtitle = " $icon "
                         . "^bg()^fg($color{'grey700'}) $windowtitle";
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
