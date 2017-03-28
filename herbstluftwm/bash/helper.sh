#!/usr/bin/env bash

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# keybindings

hlc_keybindings() {

    hckb() { herbstclient keybind "$@"; }

  # standard
  # remove all existing keybindings
    hc keyunbind --all


  # if you have a super key you will be much happier with Mod set to Mod4
  # Mod=Mod1    # Use alt as the main modifier
    Alt=Mod1
    Mod=Mod4   # Use the super key as the main modifier

    hckb $Mod-Shift-q quit
    hckb $Mod-Shift-r reload
    hckb $Mod-Shift-c close
    hckb $Mod-Return spawn ${TERMINAL:-xfce4-terminal} # use your $TERMINAL with xterm as fallback

  # epsi
    hckb $Mod-d spawn dmenu_run_hlwm
    hckb $Mod-Shift-d spawn rofi -show run -opacity 90
    hckb $Mod-Shift-x spawn oblogout

  # basic movement

  # focusing clients
    hckb $Mod-Left  focus left
    hckb $Mod-Down  focus down
    hckb $Mod-Up    focus up
    hckb $Mod-Right focus right
    hckb $Mod-h     focus left
    hckb $Mod-j     focus down
    hckb $Mod-k     focus up
    hckb $Mod-l     focus right

  # moving clients
    hckb $Mod-Shift-Left  shift left
    hckb $Mod-Shift-Down  shift down
    hckb $Mod-Shift-Up    shift up
    hckb $Mod-Shift-Right shift right
    hckb $Mod-Shift-h     shift left
    hckb $Mod-Shift-j     shift down
    hckb $Mod-Shift-k     shift up
    hckb $Mod-Shift-l     shift right

  # splitting frames
  # create an empty frame at the specified direction
    hckb $Mod-u       split   bottom  0.5
    hckb $Mod-o       split   right   0.5
  # let the current frame explode into subframes
    hckb $Mod-Control-space split explode

  # resizing frames
    resizestep=0.05
    hckb $Mod-Control-h       resize left  +$resizestep
    hckb $Mod-Control-j       resize down  +$resizestep
    hckb $Mod-Control-k       resize up    +$resizestep
    hckb $Mod-Control-l       resize right +$resizestep
    hckb $Mod-Control-Left    resize left  +$resizestep
    hckb $Mod-Control-Down    resize down  +$resizestep
    hckb $Mod-Control-Up      resize up    +$resizestep
    hckb $Mod-Control-Right   resize right +$resizestep
    
    # MPC
    hckb $Mod-Alt-h spawn mpc toggle
    hckb $Mod-Alt-t spawn mpc prev
    hckb $Mod-Alt-n spawn mpc next
    
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# tags

hlc_tags() {

    hckb() { herbstclient keybind "$@"; }

  # https://www.gnu.org/software/bash/manual/bashref.html#Brace-Expansion

  # `seq 10` 0, or $(seq 10)
    tag_names=( {1..9} 0 )        
    tag_keys=( {1..9} 0 )

    hc rename default "${tag_names[0]}" || true
    for i in ${!tag_names[@]} ; do
        hc add "${tag_names[$i]}"
        key="${tag_keys[$i]}"
        if ! [ -z "$key" ] ; then
            hc keybind "$Mod-$key" use_index "$i"
            hc keybind "$Mod-Shift-$key" move_index "$i"
        fi
     done

    hc load ${tag_names[0]} '(split horizontal:0.5:0 (clients vertical:0) (clients vertical:0))'
  # hc load ${tag_names[3]} '(split horizontal:0.5:1 (clients vertical:0) (clients vertical:0))'


  # cycle through tags
    hckb $Mod-period use_index +1 --skip-visible
    hckb $Mod-comma  use_index -1 --skip-visible

  # layouting
    hckb $Mod-r remove
    hckb $Mod-s floating toggle
    hckb $Mod-f fullscreen toggle
    hckb $Mod-p pseudotile toggle
    
  # The following cycles through the available layouts within a frame, but skips
  # layouts, if the layout change wouldn't affect the actual window positions.
  # I.e. if there are two windows within a frame, the grid layout is skipped.
    hckb $Mod-space                                                       \
            or , and . compare tags.focus.curframe_wcount = 2                   \
                     . cycle_layout +1 vertical horizontal max vertical grid    \
               , cycle_layout +1

  # mouse
    hc mouseunbind --all
    hc mousebind $Mod-Button1 move
    hc mousebind $Mod-Button2 zoom
    hc mousebind $Mod-Button3 resize

  # focus
    hckb $Mod-BackSpace   cycle_monitor
    hckb $Mod-Tab         cycle_all +1
    hckb $Mod-Shift-Tab   cycle_all -1
    hckb $Mod-c cycle
    hckb $Mod-i jumpto urgent
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# theme

hlc_theme() {

    hca() { herbstclient attr "$@"; }
    hcs() { herbstclient set "$@"; }

    hca theme.tiling.reset 1
    hca theme.floating.reset 1

    hcs frame_border_active_color '#222222'
  # hcs frame_bg_active_color '#345F0C'
    hcs frame_bg_active_color '#c9c925'

    hcs frame_border_normal_color '#101010'
  # hcs frame_bg_normal_color '#565656'
    hcs frame_bg_normal_color '#5c5dad'

  # hcs frame_border_width 1
    hcs frame_border_width 0

  # hcs always_show_frame 1
    hcs always_show_frame 0

    hcs frame_bg_transparent 1
  # hcs frame_transparent_width 5
    hcs frame_transparent_width 1

  # hcs frame_gap 4
    hcs frame_gap 10

  # hca theme.active.color '#9fbc00'
  # hca theme.normal.color '#454545'
    hca theme.active.color '#5c5dad'
    hca theme.normal.color '#202020'
    hca theme.urgent.color orange

  #hca theme.inner_width 1
    hca theme.inner_width 0
    hca theme.inner_color black

  # hca theme.border_width 3
    hca theme.border_width 1
    hca theme.floating.border_width 4
    hca theme.floating.outer_width 1
    hca theme.floating.outer_color black

    hca theme.active.inner_color '#3E4A00'
    hca theme.active.outer_color '#3E4A00'
    hca theme.background_color '#141414'

    hcs window_gap 0
    hcs frame_padding 0
    hcs smart_window_surroundings 0
    hcs smart_frame_surroundings 1
    hcs mouse_recenter_gap 0
}

# ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----- ----
# rules

hlc_rules() {

    hcr() { herbstclient rule "$@"; }

    hc unrule -F

  # hcr class=XTerm tag=3 # move all xterms to tag 3
    hcr focus=on # normally focus new clients
  # hcr focus=off # normally do not focus new clients
  # give focus to most common terminals
  # hcr class~'(.*[Rr]xvt.*|.*[Tt]erm|Konsole)' focus=on

  # zero based array
    hcr class=Firefox tag=${tag_names[1]}
    hcr class=Chromium tag=${tag_names[1]}
    hcr class=Geany tag=${tag_names[2]}
    hcr class=Thunar tag=${tag_names[3]}
    hcr class=gimp tag=${tag_names[4]} pseudotile=on

    hcr class=Oblogout fullscreen=on
    
    hcr class~'(.*[Rr]xvt.*|.*[Tt]erm|Konsole)' focus=on

    hcr windowtype~'_NET_WM_WINDOW_TYPE_(DIALOG|UTILITY|SPLASH)' pseudotile=on
  # hcr windowtype='_NET_WM_WINDOW_TYPE_DIALOG' focus=on
    hcr windowtype='_NET_WM_WINDOW_TYPE_DIALOG' fullscreen=on 
    hcr windowtype~'_NET_WM_WINDOW_TYPE_(NOTIFICATION|DOCK|DESKTOP)' manage=off
}
