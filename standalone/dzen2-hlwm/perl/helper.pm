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
    return ($geometry[0] + 0, $geometry[3] - $height, 
            $geometry[2] - 0, $height);
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen Parameters

sub get_params_top {    
    my $monitor = shift;
    my $panel_height = shift;

    my @geometry = get_geometry($monitor);
    my ($xpos, $ypos, $width, $height) = 
       get_top_panel_geometry($panel_height, @geometry); 
    
    my $bgcolor = '#000000';
    my $fgcolor = '#ffffff';
    my $font    = '-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*';

    my $parameters = "  -x $xpos -y $ypos -w $width -h $height"
                   . " -ta l -bg '$bgcolor' -fg '$fgcolor'"
                   . " -title-name dzentop"
                   . " -fn '$font'";

    return $parameters;
}

sub get_params_bottom {    
    my $monitor = shift;
    my $panel_height = shift;

    my @geometry = get_geometry($monitor);
    my ($xpos, $ypos, $width, $height) = 
       get_bottom_panel_geometry($panel_height, @geometry); 
    
    my $bgcolor = '#000000';
    my $fgcolor = '#ffffff';
    my $font    = '-*-fixed-medium-*-*-*-11-*-*-*-*-*-*-*';

    my $parameters = "  -x $xpos -y $ypos -w $width -h $height"
                   . " -ta l -bg '$bgcolor' -fg '$fgcolor'"
                   . " -title-name dzenbottom"
                   . " -fn '$font'";

    return $parameters;
}

sub get_dzen2_parameters {   
    # parameter: function argument
    my $monitor = shift;
    my $panel_height = shift;

    return get_params_top($monitor, $panel_height);
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# end of perl module

1;
