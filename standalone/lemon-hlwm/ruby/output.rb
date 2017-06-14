require_relative 'gmc'
include GMC

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# assuming $ herbstclient tag_status
# 	#1	:2	:3	:4	.5	.6	.7	.8	.9

# initialize variable segment
segment_windowtitle = ''
tags_status = []

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

# custom tag names
@TAG_SHOWS = ['一 ichi', '二 ni', '三 san', '四 shi', 
  '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū']

# initialize variable segment
@segment_windowtitle = ''
@tags_status = []

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

@SEPARATOR = "%{B-}%{F#{COLOR['yellow500']}}|%{B-}%{F-}"

# Powerline Symbol
@RIGHT_HARD_ARROW = ""
@RIGHT_SOFT_ARROW = ""
@LEFT_HARD_ARROW  = ""
@LEFT_SOFT_ARROW  = ""

# theme
@PRE_ICON    = "%{F#{COLOR['yellow500']}}"
@POST_ICON   = "%{F-}"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

def get_statusbar_text(monitor)
  text = ''

  # draw tags
  #text << '%{l}'
  @tags_status.each { |tag_status| 
    text << output_by_tag(monitor, tag_status) }
    
  # draw window title
  text << '%{r}'
  text << output_by_title()
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

def output_by_tag(monitor, tag_status)
  tag_index  = tag_status[1..1]
  tag_mark   = tag_status[0..0]
  tag_name   = @TAG_SHOWS[tag_index.to_i - 1] # zero based

  # ----- pre tag
    
  case tag_mark
  when '#'
    text_pre = "%{B#{COLOR['blue500']}}%{F#{COLOR['black']}}" \
             + "%{U#{COLOR['white']}}%{+u}#{@RIGHT_HARD_ARROW}" \
             + "%{B#{COLOR['blue500']}}%{F#{COLOR['white']}}" \
             + "%{U#{COLOR['white']}}%{+u}"
  when '+'
    text_pre = "%{B#{COLOR['yellow500']}}%{F#{COLOR['grey400']}}"
  when ':'
    text_pre = "%{B-}%{F#{COLOR['white']}}" \
             + "%{U#{COLOR['red500']}}%{+u}"
  when '!'
    text_pre = "%{B#{COLOR['red500']}}%{F#{COLOR['white']}}" \
             + "%{U#{COLOR['white']}}%{+u}"
  else
    text_pre = "%{B-}%{F#{COLOR['grey600']}}%{-u}"
  end

  # ----- tag by number

  # clickable tags
  text_name = "%{A:herbstclient focus_monitor \"#{monitor}\" && " \
            + "herbstclient use \"#{tag_index}\":} #{tag_name} %{A} "
    
  # non clickable tags
  # text_name = " #{tag_name} "
    
  # ----- post tag

  if tag_mark == '#'
    text_post = "%{B-}%{F#{COLOR['blue500']}}" \
              + "%{U#{COLOR['red500']}}%{+u}" \
              + @RIGHT_HARD_ARROW;
  else
    text_post = ""        
  end
  
  text_clear = '%{B-}%{F-}%{-u}'
     
  text_pre + text_name + text_post + text_clear
end

def output_by_title()
  text = "#{@segment_windowtitle} #{@SEPARATOR}  ";
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

def set_tag_value(monitor)
  raw = IO.popen('herbstclient tag_status ' + monitor.to_s).read()
  @tags_status = raw.strip.split("\t")
end

def set_windowtitle(windowtitle)
  icon = @PRE_ICON  + '' + @POST_ICON 

  windowtitle = windowtitle.strip
      
  @segment_windowtitle = " #{icon} %{B-}" \
    + "%{F#{COLOR['grey700']}} #{windowtitle}"
end
