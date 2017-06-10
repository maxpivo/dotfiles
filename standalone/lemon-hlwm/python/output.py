import os

from gmc import color

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# custom tag names
tag_shows = ['一 ichi', '二 ni', '三 san', '四 shi', 
    '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū']

# initialize variable segment
segment_windowtitle = ''
tags_status = []

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

separator = '%{B-}%{F' + color['yellow500'] + '}|%{B-}%{F-}'

# Powerline Symbol
right_hard_arrow = ""
right_soft_arrow = ""
left_hard_arrow  = ""
left_soft_arrow  = ""

# theme
pre_icon    = '%{F' + color['yellow500'] + '}'
post_icon   = '%{F-}'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

def get_statusbar_text(monitor):
    text = ''

    # draw tags
    text += '%{l}'
    for tag_status in tags_status:
        text += output_by_tag(monitor, tag_status)
    
    # draw window title    
    text += '%{r}'
    text += output_by_title()
    
    return text

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

def output_by_tag(monitor, tag_status):
    tag_index  = tag_status[1:2]
    tag_mark   = tag_status[0:1]
    tag_name   = tag_shows[int(tag_index) - 1] # zero based

    # ----- pre tag

    if tag_mark == '#':
        text_pre = '%{B' + color['blue500'] + '}' \
                   '%{F' + color['black'] + '}' \
                   '%{U' + color['white'] + '}%{+u}' \
                 + right_hard_arrow \
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

    # non clickable tags
    text_name = ' ' + tag_name + ' '
    
    # ----- post tag

    if tag_mark == '#':
        text_post = '%{B-}' \
                    '%{F' + color['blue500'] + '}' \
                    '%{U' + color['red500'] + '}%{+u}' \
                  + right_hard_arrow
    else: 
        text_post = ''
    
    text_clear = '%{B-}%{F-}%{-u}';
     
    return (text_pre + text_name + text_post + text_clear)

def output_by_title():
    text = segment_windowtitle + ' ' + separator + '  '

    return text

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

def set_tag_value(monitor):
    global tags_status

    raw = os.popen('herbstclient tag_status ' + str(monitor)).read()
    raw = raw.strip()
    tags_status = raw.split("\t")

def set_windowtitle(windowtitle):
    global segment_windowtitle
    icon = pre_icon + '' + post_icon
    
    windowtitle = windowtitle.strip()
      
    segment_windowtitle = ' ' + icon + \
        ' %{B-}%{F' + color['grey700'] + '} ' + windowtitle
