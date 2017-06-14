import os

from gmc import color

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# assuming $ herbstclient tag_status
# 	#1	:2	:3	:4	.5	.6	.7	.8	.9

# custom tag names
TAG_SHOWS = ['一 ichi', '二 ni', '三 san', '四 shi', 
    '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū']

# initialize variable segment
segment_windowtitle = ''
tags_status = []

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

SEPARATOR = '^bg()^fg(' + color['black'] + ')|^bg()^fg()'

# http://fontawesome.io/
FONT_AWESOME = '^fn(FontAwesome-9)'

# Powerline Symbol
RIGHT_HARD_ARROW = '^fn(powerlinesymbols-14)^fn()'
RIGHT_SOFT_ARROW = '^fn(powerlinesymbols-14)^fn()'
LEFT_HARD_ARROW  = '^fn(powerlinesymbols-14)^fn()'
LEFT_SOFT_ARROW  = '^fn(powerlinesymbols-14)^fn()'

# theme
PRE_ICON    = '^fg(' + color['yellow500'] + ')' + FONT_AWESOME
POST_ICON   = '^fn()^fg()'

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

def get_statusbar_text(monitor):
    text = ''

    # draw tags
    for tag_status in tags_status:
        text += output_by_tag(monitor, tag_status)
    
    # draw window title    
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
        text_pre = '^bg(' + color['blue500'] + ')'   \
                   '^fg(' + color['black'] + ')' \
                 + RIGHT_HARD_ARROW \
                 + '^bg(' + color['blue500'] + ')'   \
                   '^fg(' + color['white'] + ')'
    elif tag_mark == '+':
        text_pre = '^bg(' + color['yellow500'] + ')' \
                   '^fg(' + color['grey400'] + ')'
    elif tag_mark == ':':
        text_pre = '^bg()^fg(' + color['white'] + ')'
    elif tag_mark == '!':
        text_pre = '^bg(' + color['red500'] + ')'    \
                   '^fg(' + color['white'] + ')'
    else:
        text_pre = '^bg()^fg(' + color['grey600'] + ')'

   
    # ----- tag by number
   
    # assuming using dzen2_svn
    # clickable tags if using SVN dzen
    text_name = '^ca(1,herbstclient focus_monitor "' \
              + str(monitor) + '" && ' + 'herbstclient use "' \
              + tag_index + '") ' + tag_name + ' ^ca() '
    
    # ----- post tag

    if tag_mark == '#':
        text_post = '^bg(' + color['black'] + ')' \
                    '^fg(' + color['blue500'] + ')' + RIGHT_HARD_ARROW
    else: 
        text_post = ''
     
    return (text_pre + text_name + text_post)

def output_by_title():
    text  = ' ^r(5x0) ' + SEPARATOR + ' ^r(5x0) '
    text += segment_windowtitle

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
    icon = PRE_ICON + '' + POST_ICON
      
    segment_windowtitle = ' ' + icon + \
        ' ^bg()^fg(' + color['grey700'] + ') ' + windowtitle
