<?php # using PHP7
require_once(__DIR__.'/gmc.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

// custom tag names
$tag_shows = ['一 ichi', '二 ni', '三 san', '四 shi', 
  '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū'];

// initialize variable segment
$segment_windowtitle = '';
$tags_status = [];

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

$separator = "^bg()^fg(${color['black']})|^bg()^fg()";

// http://fontawesome.io/
$font_awesome = '^fn(FontAwesome-9)';

// Powerline Symbol
$right_hard_arrow = '^fn(powerlinesymbols-14)^fn()';
$right_soft_arrow = '^fn(powerlinesymbols-14)^fn()';
$left_hard_arrow  = '^fn(powerlinesymbols-14)^fn()';
$left_soft_arrow  = '^fn(powerlinesymbols-14)^fn()';

// theme
$pre_icon    = "^fg(${color['yellow500']})${font_awesome}";
$post_icon   = "^fn()^fg()";

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

function get_statusbar_text($monitor)
{
    global $tags_status;
    $text = '';
    
    // draw tags
    foreach ($tags_status as $tag_status) {
        $text .= output_by_tag($monitor, $tag_status);
     }
    
    // draw window title    
    $text .= output_leftside_top();
  
    return $text;
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

function output_by_tag($monitor, $tag_status)
{
    global $tag_shows;
    global $color, $right_hard_arrow;

    $tag_index  = substr($tag_status, 1, 1);
    $tag_mark   = substr($tag_status, 0, 1);
    $tag_name   = $tag_shows[(int)$tag_index - 1]; # zero based

    # ----- pre tag

    switch ($tag_mark) {
    case "#":
        $text_pre = "^bg(${color['blue500']})^fg(${color['black']})"
                  . $right_hard_arrow
                  . "^bg(${color['blue500']})^fg(${color['white']})";
        break;
    case "+":
        $text_pre = "^bg(${color['yellow500']})"
                  . "^fg(${color['grey400']})";       
        break;
    case ":":
        $text_pre = "^bg()^fg(${color['white']})";
        break;
    case "!":
        $text_pre = "^bg(${color['red500']})"
                  . "^fg(${color['white']})";
        break;
    default:
        $text_pre = "^bg()^fg(${color['grey600']})";
    }

    # ----- tag by number
    
    // assuming using dzen2_svn
    // clickable tags if using SVN dzen
    $text_name = "^ca(1,herbstclient focus_monitor \"${monitor}\" && " 
               . "herbstclient use \"${tag_index}\") ${tag_name} ^ca()";

    # ----- post tag

    if ($tag_mark == '#')
        $text_post = "^bg(${color['black']})^fg(${color['blue500']})" 
                   . $right_hard_arrow;
    else
        $text_post = "";
     
    return $text_pre . $text_name . $text_post;
}

function output_leftside_top()
{
    global $separator;
    global $segment_windowtitle;
    
    $text  = " ^r(5x0) $separator ^r(5x0) ";
    $text .= $segment_windowtitle;
    
    return $text;
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

function set_tag_value($monitor)
{
    global $tags_status;

    $raw = shell_exec("herbstclient tag_status $monitor");
    $tags_status = explode("\t", trim($raw));
}

function set_windowtitle($windowtitle)
{
    global $segment_windowtitle;
    global $color, $pre_icon, $post_icon;

    $icon = "${pre_icon}${post_icon}";
      
    $segment_windowtitle = " ${icon} ^bg()"
        . "^fg(${color['grey700']}) ${windowtitle}";
}
