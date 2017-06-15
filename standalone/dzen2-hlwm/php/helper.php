<?php # using PHP7

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# helpers

// script arguments
function get_monitor($arguments)
{
    // ternary operator
    return count($arguments) > 0 ? (int)$arguments[0] : 0;
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# geometry calculation

function get_geometry($monitor)
{
    $raw = shell_exec('herbstclient monitor_rect '.$monitor);

    if (empty($raw)) {
        print('Invalid monitor '.$monitors);
        exit(1);
    }
    
    return explode(' ', trim($raw));
}

function get_top_panel_geometry($height, $geometry)
{
    // geometry has the format X Y W H
    return array(
        $geometry[0], $geometry[1], $geometry[2], $height);
}

function get_bottom_panel_geometry($height, $geometry)
{
    // geometry has the format X Y W H
    return array(
        $geometry[0] + 0, ($geometry[3] - $height), 
        $geometry[2] - 0, $height);
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# dzen Parameters

function get_dzen2_parameters($monitor, $panel_height)
{
    $geometry = get_geometry($monitor);
    list($xpos, $ypos, $width, $height) = get_top_panel_geometry(
        $panel_height, $geometry);
    
    $bgcolor = '#000000';
    $fgcolor = '#ffffff';
    $font    = '-*-takaopgothic-medium-*-*-*-12-*-*-*-*-*-*-*';
  
    $parameters  = "  -x $xpos -y $ypos -w $width -h $height"
                 . " -ta l -bg '$bgcolor' -fg '$fgcolor'"
                 . " -title-name dzentop"
                 . " -fn '$font'";

    return $parameters;
}
