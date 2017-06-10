require_relative 'gmc'
include GMC

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# custom tag names
@tag_shows = ['一 ichi', '二 ni', '三 san', '四 shi', 
  '五 go', '六 roku', '七 shichi', '八 hachi', '九 kyū', '十 jū']

# initialize variable segment
@segment_windowtitle = ''
@tags_status = []

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# decoration

@separator = "%{B-}%{F#{Color['yellow500']}}|%{B-}%{F-}"

# Powerline Symbol
@right_hard_arrow = ''
@right_soft_arrow = ''
@left_hard_arrow  = ''
@left_soft_arrow  = ''

# theme
@pre_icon    = "%{F#{Color['yellow500']}}"
@post_icon   = "%{F-}"

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
  text << output_leftside_top()
  text << "\n"
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

def output_by_tag(monitor, tag_status)
  tag_index  = tag_status[1..1]
  tag_mark   = tag_status[0..0]
  tag_name   = @tag_shows[tag_index.to_i - 1] # zero based

  # ----- pre tag
    
  case tag_mark
  when '#'
    text_pre = "%{B#{Color['blue500']}}%{F#{Color['black']}}" \
             + "%{U#{Color['white']}}%{+u}#{@right_hard_arrow}" \
             + "%{B#{Color['blue500']}}%{F#{Color['white']}}" \
             + "%{U#{Color['white']}}%{+u}"
  when '+'
    text_pre = "%{B#{Color['yellow500']}}%{F#{Color['grey400']}}"
  when ':'
    text_pre = "%{B-}%{F#{Color['white']}}" \
             + "%{U#{Color['red500']}}%{+u}"
  when '!'
    text_pre = "%{B#{Color['red500']}}%{F#{Color['white']}}" \
             + "%{U#{Color['white']}}%{+u}"
  else
    text_pre = "%{B-}%{F#{Color['grey600']}}%{-u}"
  end

  # ----- tag by number
    
  # non clickable tags
  text_name = " #{tag_name} "
    
  # ----- post tag

  if tag_mark == '#'
    text_post = "%{B-}%{F#{Color['blue500']}}" \
              + "%{U#{Color['red500']}}%{+u}" \
              + @right_hard_arrow;
  else
    text_post = ""        
  end
  
  text_post << '%{B-}%{F-}%{-u}'
     
  text_pre + text_name + text_post
end

def output_leftside_top()
  text = "#{@segment_windowtitle} #{@separator}  ";
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

def set_tag_value(monitor)
  raw = IO.popen('herbstclient tag_status ' + monitor.to_s).read()
  @tags_status = raw.strip.split("\t")
end

def set_windowtitle(windowtitle)
  icon = @pre_icon + '' + @post_icon

  windowtitle = windowtitle.strip
      
  @segment_windowtitle = " #{icon} %{B-}" \
    + "%{F#{Color['grey700']}} #{windowtitle}"
end
