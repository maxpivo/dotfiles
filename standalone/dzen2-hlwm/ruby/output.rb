require_relative 'gmc'
include GMC

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# initialize

# assuming $ herbstclient tag_status
# 	#1	:2	:3	:4	.5	.6	.7	.8	.9

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

@SEPARATOR = "^bg()^fg(#{COLOR['black']})|^bg()^fg()"

# http://fontawesome.io/
@FONT_AWESOME = '^fn(FontAwesome-9)'

# Powerline Symbol
@RIGHT_HARD_ARROW = '^fn(powerlinesymbols-14)^fn()'
@RIGHT_SOFT_ARROW = '^fn(powerlinesymbols-14)^fn()'
@LEFT_HARD_ARROW  = '^fn(powerlinesymbols-14)^fn()'
@LEFT_SOFT_ARROW  = '^fn(powerlinesymbols-14)^fn()'

# theme
@PRE_ICON    = "^fg(#{COLOR['yellow500']})#{@FONT_AWESOME}"
@POST_ICON   = "^fn()^fg()"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

def get_statusbar_text(monitor)
  text = ''

  # draw tags
  @tags_status.each { |tag_status| 
    text << output_by_tag(monitor, tag_status) }
    
  # draw window title    
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
    text_pre = "^bg(#{COLOR['blue500']})^fg(#{COLOR['black']})" \
             + @RIGHT_HARD_ARROW \
             + "^bg(#{COLOR['blue500']})^fg(#{COLOR['white']})"
  when '+'
    text_pre = "^bg(#{COLOR['yellow500']})^fg(#{COLOR['grey400']})"
  when ':'
    text_pre = "^bg()^fg(#{COLOR['white']})"
  when '!'
    text_pre = "^bg(#{COLOR['red500']})^fg(#{COLOR['white']})"
  else
    text_pre = "^bg()^fg(#{COLOR['grey600']})"
  end
   
  # ----- tag by number
    
  # assuming using dzen2_svn
  # clickable tags if using SVN dzen
  text_name = "^ca(1,herbstclient focus_monitor \"#{monitor}\" && " \
            + "herbstclient use \"#{tag_index}\") #{tag_name} ^ca() "
    
  # ----- post tag

  if tag_mark == '#'
    text_post = "^bg(#{COLOR['black']})^fg(#{COLOR['blue500']})" \
              + @RIGHT_HARD_ARROW
  else
    text_post = ""        
  end
     
  text_pre + text_name + text_post
end

def output_by_title()
  text  = " ^r(5x0) #{@SEPARATOR} ^r(5x0) "  
  text << @segment_windowtitle
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

def set_tag_value(monitor)
  raw = IO.popen('herbstclient tag_status ' + monitor.to_s).read()
  @tags_status = raw.strip.split("\t")
end

def set_windowtitle(windowtitle)
  icon = @PRE_ICON + '' + @POST_ICON
      
  @segment_windowtitle = " #{icon} ^bg()" \
    + "^fg(#{COLOR['grey700']}) #{windowtitle}"
end
