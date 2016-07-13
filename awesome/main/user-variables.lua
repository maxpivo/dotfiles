-- {{{ Global Variable Definitions
-- moved here in module as local variable
-- }}}

local _M = {
  -- This is used later as the default terminal and editor to run.
  -- RC.terminal = "xfce4-terminal"
  terminal = "termite",

  -- Default modkey. Usually the key with a logo between Control and Alt.
  modkey = "Mod4",

  -- user defined wallpaper
  --wallpaper = nil,
  --wallpaper = "/Pictures/your-wallpaper-here.jpg",
  wallpaper = "/Pictures/white/french_marigold_yellow-wallpaper-1280x800.jpg",

  -- device, used in vicious widget
  -- wlandev = 'wlan0',
  wlandev = 'wlp0s3f3u2',

  -- statusbar module
  -- choice: simple, vicious, lain
  statusbarmodule = 'lain'

}

return _M
