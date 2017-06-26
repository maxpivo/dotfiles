import os
import datetime
import time

from gmc import color

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# assuming $ herbstclient tag_status
# 	#1	:2	:3	:4	.5	.6	.7	.8	.9

# custom tag names
TAG_SHOWS = ['一 ichi', '二 ni', '三 san', '四 shi', 
    '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū']

# initialize variable segment
segment_windowtitle = '' # empty string
tags_status         = [] # empty list
segment_datetime    = '' # empty string

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

SEPARATOR = '%{B-}%{F' + color['yellow500'] + '}|%{B-}%{F-}'

# Powerline Symbol
RIGHT_HARD_ARROW = ""
RIGHT_SOFT_ARROW = ""
LEFT_HARD_ARROW  = ""
LEFT_SOFT_ARROW  = ""

# theme
PRE_ICON    = '%{F' + color['yellow500'] + '}'
POST_ICON   = '%{F-}'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

def get_statusbar_text(monitor):
    text = ''

    # draw tags
    text += '%{l}'
    for tag_status in tags_status:
        text += output_by_tag(monitor, tag_status)

    # draw date and time
    text += '%{c}'
    text += output_by_datetime()

    # draw window title    
    text += '%{r}'
    text += output_by_title()
    
    return text

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

def output_by_tag(monitor, tag_status):
    tag_index  = tag_status[1:2]
    tag_mark   = tag_status[0:1]
    tag_name   = TAG_SHOWS[int(tag_index) - 1] # zero based

    # ----- pre tag

    if tag_mark == '#':
        text_pre = '%{B' + color['blue500'] + '}' \
                   '%{F' + color['black'] + '}' \
                   '%{U' + color['white'] + '}%{+u}' \
                 + RIGHT_HARD_ARROW \
                 + '%{B' + color['blue500'] + '}' \
                   '%{F' + color['white'] + '}' \
                   '%{U' + color['white'] + '}%{+u}'
    elif tag_mark == '+':
        text_pre = '%{B' + color['yellow500'] + '}' \
                   '%{F' + color['grey400'] + '}'
    elif tag_mark == ':':
        text_pre = '%{B-}%{F' + color['white'] + '}' \
                   '%{U' + color['red500'] + '}%{+u}'
    elif tag_mark == '!':
        text_pre = '%{B' + color['red500'] + '}' \
                   '%{F' + color['white'] + '}' \
                   '%{U' + color['white'] + '}%{+u}'
    else:
        text_pre = '%{B-}%{F' + color['grey600'] + '}%{-u}'

    # ----- tag by number
    
    # clickable tags
    text_name = '%{A:herbstclient focus_monitor "' \
              + str(monitor) + '" && ' + 'herbstclient use "' \
              + tag_index + '":} ' + tag_name + ' %{A} '

    # non clickable tags
    # text_name = ' ' + tag_name + ' '
    
    # ----- post tag

    if tag_mark == '#':
        text_post = '%{B-}' \
                    '%{F' + color['blue500'] + '}' \
                    '%{U' + color['red500'] + '}%{+u}' \
                  + RIGHT_HARD_ARROW
    else: 
        text_post = ''
    
    text_clear = '%{B-}%{F-}%{-u}';
     
    return (text_pre + text_name + text_post + text_clear)

def output_by_title():
    text = segment_windowtitle + ' ' + SEPARATOR + '  '

    return text

def output_by_datetime():
    return segment_datetime

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

def set_tag_value(monitor):
    global tags_status

    raw = os.popen('herbstclient tag_status ' + str(monitor)).read()
    raw = raw.strip()
    tags_status = raw.split("\t")

def set_windowtitle(windowtitle):
    global segment_windowtitle
    icon = PRE_ICON + '' + POST_ICON

    segment_windowtitle = ' ' + icon + \
        ' %{B-}%{F' + color['grey700'] + '} ' + windowtitle

def set_datetime():
    global segment_datetime
    now = datetime.datetime.now()
    
    date_icon   = PRE_ICON + '' + POST_ICON
    date_format = '{0:%Y-%m-%d}'
    date_str  = date_format.format(now)
    date_text = date_icon + ' %{B-}' \
              + '%{F' + color['grey700'] + '} ' + date_str

    time_icon   = PRE_ICON + '' + POST_ICON    
    time_format = '{0:%H:%M:%S}'
    time_str  = time_format.format(now)
    time_text = time_icon +' %{B-}' \
              + '%{F' + color['blue500'] + '} ' + time_str

    segment_datetime = date_text + '  ' + time_text
