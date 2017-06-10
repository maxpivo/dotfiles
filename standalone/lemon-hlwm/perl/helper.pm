package helper;

use warnings;
use strict;

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# helpers

# script arguments
sub get_monitor {
    my @arguments = @_; 
    my $num_args  = $#arguments;
   
    # ternary operator
    my $monitor = ($num_args > 0) ? $arguments[0] : 0;
    
    return $monitor;
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# geometry calculation

sub get_geometry {
    my $monitor = shift;

    my $geometry_qx = qx(herbstclient monitor_rect "$monitor");
    if ($geometry_qx eq "") { 
        print "Invalid monitor $monitor\n";
        exit 1
    }
    
    my @geometry = split / /, $geometry_qx;
    
    return @geometry;
}

sub get_top_panel_geometry {
    my $height = shift;
    my @geometry = @_;

    # geometry has the format X Y W H
    return ($geometry[0], $geometry[1], $geometry[2], $height);
}

sub get_bottom_panel_geometry {
    my $height = shift;
    my @geometry = @_;

    # geometry has the format X Y W H
    return ($geometry[0], $geometry[3]-$height, $geometry[2], $height);
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# lemon Parameters

sub get_lemon_parameters {   
    # parameter: function argument
    my $monitor = shift;
    my $panel_height = shift;

    # calculate geometry
    my @geometry = get_geometry($monitor);
    my ($xpos, $ypos, $width, $height) = 
       get_top_panel_geometry($panel_height, @geometry); 

    # geometry: -g widthxheight+x+y
    my $geom_res = "${width}x${height}+${xpos}+${ypos}";
    
    # color, with transparency
    my $bgcolor = '#aa000000';
    my $fgcolor = '#ffffff';
    
    # XFT: require lemonbar_xft_git 
    my $font_takaop  = "takaopgothic-9";
    my $font_bottom  = "monospace-9";
    my $font_symbol  = "PowerlineSymbols-11";
    my $font_awesome = "FontAwesome-9";

    # finally
    my $parameters = "  -g $geom_res -u 2"
                   . " -B $bgcolor -F $fgcolor"
                   . " -f $font_takaop -f $font_awesome -f $font_symbol";

    return $parameters;
}


# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
