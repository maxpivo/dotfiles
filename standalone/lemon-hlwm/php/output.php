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
$segment_windowtitle = '';
$tags_status = [];

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

const SEPARATOR = "%{B-}%{F".COLOR['yellow500']."}|%{B-}%{F-}";

// Powerline Symbol
const RIGHT_HARD_ARROW = "";
const RIGHT_SOFT_ARROW = "";
const LEFT_HARD_ARROW  = "";
const LEFT_SOFT_ARROW  = "";

// theme
const PRE_ICON    = "%{F".COLOR['yellow500']."}";
const POST_ICON   = "%{F-}";

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
    $tag_index  = substr($tag_status, 1, 1);
    $tag_mark   = substr($tag_status, 0, 1);
    $tag_name   = TAG_SHOWS[(int)$tag_index - 1]; # zero based

    # ----- pre tag

    switch ($tag_mark) {
    case "#":
        $text_pre = "%{B".COLOR['blue500']."}%{F".COLOR['black']."}"
                  . "%{U".COLOR['white']."}%{+u}".RIGHT_HARD_ARROW
                  . "%{B".COLOR['blue500']."}%{F".COLOR['white']."}"
                  . "%{U".COLOR['white']."}%{+u}";
        break;
    case "+":
        $text_pre = "%{B".COLOR['yellow500']."}%{F".COLOR['grey400']."}";
        break;
    case ":":
        $text_pre = $text_pre = "%{B-}%{F".COLOR['white']."}"
                  . "%{U".COLOR['red500']."}%{+u}";
        break;
    case "!":
        $text_pre = "%{B".COLOR['red500']."}%{F".COLOR['white']."}"
                  . "%{U".COLOR['white']."}%{+u}";
        break;
    default:
        $text_pre = "%{B-}%{F".COLOR['grey600']."}%{-u}";
    }

    # ----- tag by number
    
    // clickable tags
    $text_name = "%{A:herbstclient focus_monitor \"${monitor}\" && " 
               . "herbstclient use \"${tag_index}\":} ${tag_name} %{A}";
    
    # non clickable tags
    #$text_name = " $tag_name ";

    # ----- post tag

    if ($tag_mark == '#')
        $text_post = "%{B-}%{F".COLOR['blue500']."}"
                   . "%{U".COLOR['red500']."}%{+u}"
                   . RIGHT_HARD_ARROW;
    else
        $text_post = "";

    $text_clear = '%{B-}%{F-}%{-u}';
     
    return $text_pre . $text_name . $text_post . $text_clear;
}

function output_by_title()
{
    global $segment_windowtitle;    
    $text  = "$segment_windowtitle ".SEPARATOR."  ";
    
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
    
    $windowtitle = trim($windowtitle);
      
    $segment_windowtitle = " ${icon} %{B-}"
        . "%{F".COLOR['grey700']."} ${windowtitle}";
}
