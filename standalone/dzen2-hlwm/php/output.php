<?php # using PHP7
require_once(__DIR__.'/gmc.php');

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

// assuming $ herbstclient tag_status
// 	#1	:2	:3	:4	.5	.6	.7	.8	.9

// custom tag names
const TAG_SHOWS = ['一 ichi', '二 ni', '三 san', '四 shi', 
  '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū'];

// initialize variable segment
$segment_windowtitle = ''; # empty string
$tags_status         = []; # empty array
$segment_datetime    = ''; # empty string

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

const SEPARATOR = "^bg()^fg(".COLOR['black'].")|^bg()^fg()";

// http://fontawesome.io/
const FONT_AWESOME = '^fn(FontAwesome-9)';

// Powerline Symbol
const RIGHT_HARD_ARROW = '^fn(powerlinesymbols-14)^fn()';
const RIGHT_SOFT_ARROW = '^fn(powerlinesymbols-14)^fn()';
const LEFT_HARD_ARROW  = '^fn(powerlinesymbols-14)^fn()';
const LEFT_SOFT_ARROW  = '^fn(powerlinesymbols-14)^fn()';

// theme
const PRE_ICON    = "^fg(".COLOR['yellow500'].")".FONT_AWESOME;
const POST_ICON   = "^fn()^fg()";

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
    
    //# draw date and time
    $text .= output_by_datetime();
    
    // draw window title    
    $text .= output_by_title();
  
    return $text;
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

function output_by_tag($monitor, $tag_status)
{
    $tag_index  = substr($tag_status, 1, 1);
    $tag_mark   = substr($tag_status, 0, 1);
    $tag_name   = TAG_SHOWS[(int)$tag_index - 1]; # zero based

    # ----- pre tag

    switch ($tag_mark) {
    case "#":
        $text_pre = "^bg(".COLOR['blue500'].")^fg(".COLOR['black'].")"
                  . RIGHT_HARD_ARROW
                  . "^bg(".COLOR['blue500'].")^fg(".COLOR['white'].")";
        break;
    case "+":
        $text_pre = "^bg(".COLOR['yellow500'].")"
                  . "^fg(".COLOR['grey400'].")";       
        break;
    case ":":
        $text_pre = "^bg()^fg(".COLOR['white'].")";
        break;
    case "!":
        $text_pre = "^bg(".COLOR['red500'].")"
                  . "^fg(".COLOR['white'].")";
        break;
    default:
        $text_pre = "^bg()^fg(".COLOR['grey600'].")";
    }

    # ----- tag by number
    
    // assuming using dzen2_svn
    // clickable tags if using SVN dzen
    $text_name = "^ca(1,herbstclient focus_monitor \"${monitor}\" && " 
               . "herbstclient use \"${tag_index}\") ${tag_name} ^ca()";

    # ----- post tag

    if ($tag_mark == '#')
        $text_post = "^bg(".COLOR['black'].")^fg(".COLOR['blue500'].")" 
                   . RIGHT_HARD_ARROW;
    else
        $text_post = "";
     
    return $text_pre . $text_name . $text_post;
}

function output_by_title()
{
    global $segment_windowtitle;
    
    $text  = " ^r(5x0) ".SEPARATOR." ^r(5x0) ";
    $text .= $segment_windowtitle;
    
    return $text;
}

function output_by_datetime()
{
    global $segment_datetime; 
    
    $text  = " ^r(5x0) ".SEPARATOR." ^r(5x0) ";
    $text .= $segment_datetime;
    
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
    $icon = PRE_ICON."".POST_ICON;
      
    $segment_windowtitle = " ${icon} ^bg()"
        . "^fg(".COLOR['grey700'].") $windowtitle";
}

function set_datetime() {
    global $segment_datetime;

    $date_icon = PRE_ICON."".POST_ICON;
    $date_format = '%a %b %d';
    $date_str  = strftime($date_format);
    $date_text = "$date_icon ^bg()^fg(".COLOR['grey700'].") $date_str";

    $time_icon = PRE_ICON."".POST_ICON;
    $time_format = '%H:%M:%S';
    $time_str = strftime($time_format);
    $time_text = "$time_icon ^bg()^fg(".COLOR['blue500'].") $time_str";

    $segment_datetime = "$date_text  $time_text";
}
