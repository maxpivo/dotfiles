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

$separator = "%{B-}%{F${color['yellow500']}}|%{B-}%{F-}";

// Powerline Symbol
$right_hard_arrow = "";
$right_soft_arrow = "";
$left_hard_arrow  = "";
$left_soft_arrow  = "";

// theme
$pre_icon    = "%{F${color['yellow500']}}";
$post_icon   = "%{F-}";

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

function get_statusbar_text($monitor)
{
    global $tags_status;
    $text = '';
    
    // draw tags
    $text .= '%{l}';
    foreach ($tags_status as $tag_status) {
        $text .= output_by_tag($monitor, $tag_status);
     }
    
    // draw window title
    $text .= '%{r}';
    $text .= output_by_title();

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
        $text_pre = "%{B${color['blue500']}}%{F${color['black']}}"
                  . "%{U${color['white']}}%{+u}$right_hard_arrow"
                  . "%{B${color['blue500']}}%{F${color['white']}}"
                  . "%{U${color['white']}}%{+u}";
        break;
    case "+":
        $text_pre = "%{B${color['yellow500']}}%{F${color['grey400']}}";      
        break;
    case ":":
        $text_pre = $text_pre = "%{B-}%{F${color['white']}}"
                  . "%{U${color['red500']}}%{+u}";
        break;
    case "!":
        $text_pre = "%{B${color['red500']}}%{F${color['white']}}"
                  . "%{U${color['white']}}%{+u}";
        break;
    default:
        $text_pre = "%{B-}%{F" . $color['grey600'] . "}%{-u}";
    }

    # ----- tag by number
    
    # non clickable tags
    $text_name = " $tag_name ";

    # ----- post tag

    if ($tag_mark == '#')
        $text_post = "%{B-}%{F${color['blue500']}}"
                   . "%{U${color['red500']}}%{+u}"
                   . $right_hard_arrow;
    else
        $text_post = "";

    $text_clear = '%{B-}%{F-}%{-u}';
     
    return $text_pre . $text_name . $text_post . $text_clear;
}

function output_by_title()
{
    global $separator;
    global $segment_windowtitle;
    
    $text  = "$segment_windowtitle $separator  ";
    
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
    
    $windowtitle = trim($windowtitle);
      
    $segment_windowtitle = " ${icon} %{B-}"
        . "%{F${color['grey700']}} ${windowtitle}";
}
