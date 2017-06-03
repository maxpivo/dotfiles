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

@separator = "^bg()^fg(#{Color['black']})|^bg()^fg()"

# http://fontawesome.io/
@font_awesome = '^fn(FontAwesome-9)'

# Powerline Symbol
@right_hard_arrow = '^fn(powerlinesymbols-14)^fn()'
@right_soft_arrow = '^fn(powerlinesymbols-14)^fn()'
@left_hard_arrow  = '^fn(powerlinesymbols-14)^fn()'
@left_soft_arrow  = '^fn(powerlinesymbols-14)^fn()'

# theme
@pre_icon    = "^fg(#{Color['yellow500']})#{@font_awesome}"
@post_icon   = "^fn()^fg()"

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# main

def get_statusbar_text(monitor)
  text = ''

  # draw tags
  @tags_status.each { |tag_status| 
    text << output_by_tag(monitor, tag_status) }
    
  # draw window title    
  text << output_leftside_top()
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# each segments

def output_by_tag(monitor, tag_status)
  text = ''

  tag_index  = tag_status[1..1]
  tag_mark   = tag_status[0..0]
  tag_name   = @tag_shows[tag_index.to_i - 1] # zero based

  # ----- pre tag
    
  case tag_mark
  when '#'
    text << "^bg(#{Color['blue500']})^fg(#{Color['black']})#{@right_hard_arrow}"
    text << "^bg(#{Color['blue500']})^fg(#{Color['white']})"
  when '+'
    text << "^bg(#{Color['yellow500']})^fg(#{Color['grey400']})";
  when ':'
    text << "^bg()^fg(#{Color['white']})"
  when '!'
    text << "^bg(#{Color['red500']})^fg(#{Color['white']})"
  else
    text << "^bg()^fg(#{Color['grey600']})"
  end
   
  # ----- tag by number
    
  # assuming using dzen2_svn
  # clickable tags if using SVN dzen
  text << "^ca(1,herbstclient focus_monitor \"#{monitor}\" && " \
        + "herbstclient use \"#{tag_index}\") #{tag_name} ^ca() "
    
  # ----- post tag

  if tag_mark == '#'
    text << "^bg(#{Color['black']})^fg(#{Color['blue500']})" \
          + @right_hard_arrow
  end
     
  text
end

def output_leftside_top()
  text  = " ^r(5x0) #{@separator} ^r(5x0) "  
  text << @segment_windowtitle
end

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# setting variables, response to event handler

def set_tag_value(monitor)
  raw = IO.popen('herbstclient tag_status ' + monitor.to_s).read()
  @tags_status = raw.strip.split("\t")
end

def set_windowtitle(windowtitle)
  icon = @pre_icon + '' + @post_icon
      
  @segment_windowtitle = " #{icon} ^bg()" \
    + "^fg(#{Color['grey700']}) #{windowtitle}"
end
