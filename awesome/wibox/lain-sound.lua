--[[
     Original Source Modified From: github.com/copycat-killer
     https://github.com/copycat-killer/awesome-copycats/blob/master/rc.lua.copland
--]]

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- Standard awesome library
local beautiful = require("beautiful")

-- Wibox handling library
local wibox = require("wibox")
local lain = require("lain")

local W = multicolor_widget_set     -- object name
local I = multicolor_icon_set       -- object name

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- ALSA volume from copycat-multicolor
I.volume = wibox.widget.imagebox(beautiful.widget_vol)

W.volume = lain.widgets.alsa({
    settings = function()
        if volume_now.status == "off" then
            volume_now.level = volume_now.level .. "M"
        end

        widget:set_markup(markup("#7493d2", volume_now.level .. "% "))
    end
})

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- ALSA volume bar

-- global terminal is required in alsabar
terminal = RC.terminal

-- ALSA volume bar from copycat-rainbow
--[[
W.volume_wibox = lain.widgets.alsabar({ card = "0", ticks = true })

W.volume_margin = wibox.layout.margin(W.volume_wibox.bar, 5, 8, 80)
W.volume_margin:set_top(7)
W.volume_margin:set_bottom(7)

W.volume_bar_widget = wibox.widget.background(W.volume_margin)
W.volume_bar_widget:set_bgimage(beautiful.bar_bg_rainbow)
]]

-- ALSA volume bar from copycat-copland

I.volume_dynamic = wibox.widget.imagebox(beautiful.monitor_vol)

local volume_wibox_settings = function()
    if volume_now.status == "off" then
        I.volume_dynamic:set_image(beautiful.monitor_vol_mute)
    elseif volume_now.level == 0 then
        I.volume_dynamic:set_image(beautiful.monitor_vol_no)
    elseif volume_now.level <= 50 then
        I.volume_dynamic:set_image(beautiful.monitor_vol_low)
    else
        I.volume_dynamic:set_image(beautiful.monitor_vol)
    end
end

local volume_wibox_colors = {
    background = beautiful.bg_normal,
    mute = red,
    unmute = beautiful.fg_normal
}

W.volume_wibox = lain.widgets.alsabar({
  width = 55, ticks = true, ticks_size = 6, step = "2%",
  settings = volume_wibox_settings,
  colors = volume_wibox_colors
})

W.volume_margin = wibox.layout.margin(W.volume_wibox.bar, 2, 7)
W.volume_margin:set_top(6)
W.volume_margin:set_bottom(6)
W.volume_bar_widget = wibox.widget.background(W.volume_margin)
W.volume_bar_widget:set_bgimage(beautiful.bar_bg_copland)


-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --

-- MPD from copycat-multicolor

I.mpd = wibox.widget.imagebox()
W.mpd = lain.widgets.mpd({
    settings = function()
        mpd_notification_preset = {
            text = string.format("%s [%s] - %s\n%s", mpd_now.artist,
                   mpd_now.album, mpd_now.date, mpd_now.title)
        }

        if mpd_now.state == "play" then
            artist = mpd_now.artist .. " > "
            title  = mpd_now.title .. " "
            I.mpd:set_image(beautiful.widget_note_on)
        elseif mpd_now.state == "pause" then
            artist = "mpd "
            title  = "paused "
        else
            artist = ""
            title  = ""
            I.mpd:set_image(nil)
        end
        widget:set_markup(markup("#e54c62", artist)
          .. markup("#b2b2b2", title))
    end
})
