--[[

     Blackburn Awesome WM theme 3.0
     github.com/lcpz

--]]

local gears = require("gears")
local lain  = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local menubar = require("menubar")

-- Import Keybinds
local keys = require("keys")
local dpi   = require("beautiful.xresources").apply_dpi
-- Desktop icon & menu library
local freedesktop   = require("lib.freedesktop")

local hotkeys_popup = require("lib.awful.hotkeys_popup").widget

local os = os
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local poly = function(cr, width, height)
    gears.shape.octogon(cr, width, height)
end

local theme                                     = {}

theme.hotkeys_border_width                      = dpi(0)
theme.hotkeys_bg                                = "#000000"
theme.hotkeys_fg                                = "#e5e5e5"
theme.hotkeys_modifiers_bg                      = "#464145"
theme.hotkeys_modifiers_fg                      = "#464145"
theme.hotkeys_border_color                      = "#000000"
theme.hotkeys_description_font                  = "pf tempesta five compressed 9"
theme.hotkeys_font                              = "pf tempesta five compressed 11"
theme.hotkeys_shape                             = poly
theme.icon_theme                                = 'ePapirus-Dark' , 'Adwaita' , 'Mist', 'gnome'
theme.dir                                       = os.getenv("HOME") .. "/.config/awesome/themes/dark"
theme.font                                      = "Terminus 11"
theme.taglist_font                              = "Terminus 11"
theme.fg_normal                                 = "#D7D7D7"
theme.fg_focus                                  = "#a951f6"
theme.bg_normal                                 = "#000000"
theme.bg_focus                                  = "#000000"
theme.fg_urgent                                 = "#b293cc"
theme.bg_urgent                                 = "#251e2a"
theme.border_width                              = dpi(1)
theme.border_normal                             = "#000000"
theme.border_focus                              = "#c973f7"
theme.taglist_fg_focus                          = "#b151f6"
theme.taglist_bg_focus                          = "#000000"
theme.tasklist_fg_focus                         = "#b151f6"
theme.tasklist_bg_focus                         = "#000000"
theme.arrow_color                               = "#1A1A1A"
theme.arrow_color_darker                        = "#090909"
theme.menu_height                               = dpi(16)
theme.menu_width                                = dpi(130)
theme.menu_submenu_icon                         = theme.dir .. "/icons/submenu.png"
theme.awesome_icon                              = theme.dir .. "/icons/awesome.png"
theme.terminal_icon                             = theme.dir .. "/icons/terminal.png"
theme.trash_icon                                = theme.dir .. "/icons/trash.png"
theme.power_icon                                = theme.dir .. "/icons/power.png"
theme.volume_icon                               = theme.dir .. "/icons/volume/volume.png"
theme.volume_low_icon                           = theme.dir .. "/icons/volume/volume-low.png"
theme.volume_off_icon                           = theme.dir .. "/icons/volume/volume-off.png"
theme.taglist_squares_sel                       = theme.dir .. "/icons/square_sel.png"
theme.taglist_squares_unsel                     = theme.dir .. "/icons/square_unsel.png"
theme.layout_tile                               = theme.dir .. "/icons/layout/tile.png"
theme.layout_tileleft                           = theme.dir .. "/icons/layout/tileleft.png"
theme.layout_tilebottom                         = theme.dir .. "/icons/layout/tilebottom.png"
theme.layout_tiletop                            = theme.dir .. "/icons/layout/tiletop.png"
theme.layout_fairv                              = theme.dir .. "/icons/layout/fairv.png"
theme.layout_fairh                              = theme.dir .. "/icons/layout/fairh.png"
theme.layout_spiral                             = theme.dir .. "/icons/layout/spiral.png"
theme.layout_dwindle                            = theme.dir .. "/icons/layout/dwindle.png"
theme.layout_max                                = theme.dir .. "/icons/layout/max.png"
theme.layout_fullscreen                         = theme.dir .. "/icons/layout/fullscreen.png"
theme.layout_magnifier                          = theme.dir .. "/icons/layout/magnifier.png"
theme.layout_floating                           = theme.dir .. "/icons/layout/floating.png"
theme.layout_centerfair                         = theme.dir .. "/icons/layout/centerfair.png"
theme.layout_cascade                            = theme.dir .. "/icons/layout/cascade.png"
theme.layout_centerwork                         = theme.dir .. "/icons/layout/centerwork.png"
theme.layout_centerworkh                        = theme.dir .. "/icons/layout/centerworkh.png"
theme.layout_termfair                           = theme.dir .. "/icons/layout/termfair.png"
theme.tasklist_plain_task_name                  = true
theme.tasklist_disable_icon                     = false
theme.useless_gap                               = 0
theme.titlebars_enabled                         = false
theme.titlebar_close_button_focus               = theme.dir .. "/icons/titlebar/close_focus.png"
theme.titlebar_close_button_normal              = theme.dir .. "/icons/titlebar/close_normal.png"
theme.titlebar_ontop_button_focus_active        = theme.dir .. "/icons/titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active       = theme.dir .. "/icons/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive      = theme.dir .. "/icons/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive     = theme.dir .. "/icons/titlebar/ontop_normal_inactive.png"
theme.titlebar_sticky_button_focus_active       = theme.dir .. "/icons/titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active      = theme.dir .. "/icons/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive     = theme.dir .. "/icons/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive    = theme.dir .. "/icons/titlebar/sticky_normal_inactive.png"
theme.titlebar_floating_button_focus_active     = theme.dir .. "/icons/titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active    = theme.dir .. "/icons/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive   = theme.dir .. "/icons/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive  = theme.dir .. "/icons/titlebar/floating_normal_inactive.png"
theme.titlebar_maximized_button_focus_active    = theme.dir .. "/icons/titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active   = theme.dir .. "/icons/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "/icons/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "/icons/titlebar/maximized_normal_inactive.png" 
theme.titlebarheight = 17

awful.util.tagnames = {"⋊","⋈","⋉"}

local markup     = lain.util.markup
local separators = lain.util.separators
local gray       = "#dddddd"

-- Textclock
--local mytextclock = wibox.widget.textclock("  %H:%M  ") -- european format
local mytextclock = wibox.widget.textclock(" %I:%M ") -- american format
mytextclock.font = theme.font

-- Keyboard layout
local mykeyboardlayout = awful.widget.keyboardlayout()
mykeyboardlayout.font = theme.font

-- Awesome Menu

-- ===================================================================
-- Desktop
-- ===================================================================

local myawesomemenu  = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "arandr", "arandr" },
    --{ "manual", apps.terminal .. " -e man awesome" },
    { "edit config", string.format("%s %s/.config/awesome/rc.lua",apps.editorgui, os.getenv("HOME")) },
    { "edit keys", string.format("%s %s/.config/awesome/keys.lua",apps.editorgui, os.getenv("HOME")) },
    { "edit rules", string.format("%s %s/.config/awesome/rules.lua",apps.editorgui, os.getenv("HOME")) },
    { "edit theme", string.format("%s %s/theme.lua",apps.editorgui, theme.dir) },
    { "refresh", awesome.restart },
}

mymainmenu = freedesktop.menu.build({
    before = {
        { "Awesome", myawesomemenu, theme.awesome_icon },
    },
    after = {
        { "Terminal", apps.terminal , theme.terminal_icon },
        { "Power", string.format("kitty --detach --title powermenu --start-as minimized %s/.config/awesome/scripts/powermenu.sh", os.getenv("HOME")) , theme.power_icon },
    }
})

-- hide menu when mouse leaves it
mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not mymainmenu.active_child or
    (mymainmenu.wibox ~= mouse.current_wibox and
    mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        mymainmenu:hide()
    else
        mymainmenu.active_child.wibox:connect_signal("mouse::leave",
        function()
            if mymainmenu.wibox ~= mouse.current_wibox then
                mymainmenu:hide()
            end
        end)
    end
end)

local mylauncher = awful.widget.launcher({ image = theme.awesome_icon,menu = mymainmenu })

menubar.utils.terminal = apps.terminal

-- Calendar
theme.cal = lain.widget.cal({
    attach_to = { mytextclock },
    notification_preset = {
        font = "Terminus 11",
        fg   = theme.fg_normal,
        bg   = theme.bg_normal
    }
})

-- Mail IMAP check
--[[ commented because it needs to be set before use
theme.mail = lain.widget.imap({
    timeout  = 180,
    server   = "server",
    mail     = "mail",
    password = "keyring get mail",
    notification_preset = { fg = white }
    settings = function()
        mail  = ""
        count = ""

        if mailcount > 0 then
            mail = "Mail "
            count = mailcount .. " "
        end

        widget:set_markup(markup.font(theme.font, markup(gray, mail) .. count))
    end
})
--]]


--MPD
theme.mpd = lain.widget.mpd({
    settings = function()
        mpd_notification_preset.fg = white
        artist = mpd_now.artist .. " "
        title  = mpd_now.title  .. " "
        time = mpd_now.time .. " "
        ctime = mpd_now.elapsed .. " "
        file = mpd_now.file:gsub(".mp3", "") .. " "
        x = ""
        if mpd_now.state == "play" then
            x = " "
        elseif mpd_now.state == "stop" then
            x = " "
            file = ""          
        elseif mpd_now.state == "pause" then
            x = " "
        end

        widget:set_markup(markup.font(theme.font," " .. markup(gray, x)))
        --widget:set_markup(markup.font(theme.font," " .. markup(gray, x) .. markup(gray,file)))
        --widget:set_markup(markup.font(theme.font,markup(gray, title) .. ctime .. "/" .. time .. "♫ "))
        --widget:set_markup(markup.font(theme.font,markup(gray, artist) .. title .. ctime .. "/" .. time .. "♫ "))
    end
})

theme.mpd.widget:buttons(awful.util.table.join(
                               awful.button({}, 1, function ()
                                awful.spawn.with_shell("$HOME/.config/awesome/scripts/musiccontrol.sh")
                               end)
                               --awful.button({}, 4, function ()
                               -- awful.util.spawn("mpc next") theme.mpd.update()
                               --end),
                               --awful.button({}, 5, function ()
                               -- awful.util.spawn("mpc prev") theme.mpd.update()
                               --end)
))
--]]

-- /home fs
--[[ commented because it needs Gio/Glib >= 2.54
theme.fs = lain.widget.fs({
    notification_preset = { fg = white, bg = theme.bg_normal, font = "Terminus 10.5" },
    settings  = function()
        fs_header = ""
        fs_p      = ""

        if fs_now["/home"].percentage >= 90 then
            fs_header = " Hdd "
            fs_p      = fs_now["/home"].percentage
        end

        widget:set_markup(markup.font(theme.font, markup(gray, fs_header) .. fs_p))
    end
})
--]]

--
-- Battery
local battery = lain.widget.bat({
    settings = function()
        bat_header = " Bat "
        bat_p      = bat_now.perc .. " "
        widget:set_markup(markup.font(theme.font, markup(gray, bat_header) .. bat_p))
    end
})
--

-- ALSA volume
local voluicon = wibox.widget.imagebox(volume_icon)
voluicon:buttons(awful.util.table.join(
                               awful.button({}, 1, function ()
                                     awful.util.spawn("pavucontrol")
                               end),
                               awful.button({}, 4, function ()
                                     awful.util.spawn("pamixer -d 5", false)
                                     awesome.emit_signal("volume_change")
                                     theme.volume.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("pamixer -i 5", false)
                                     awesome.emit_signal("volume_change")
                                     theme.volume.update()
                               end)
))

theme.volume = lain.widget.pipewire({
    settings = function()
        if volume_now.level == nil or volume_now.level == "" then
            volume_now.level = ""
            voluicon:set_image(theme.volume_off_icon)
            widget:set_markup(markup.font(theme.font, "" .. string.format(volume_now.level) ))
        else
            if tonumber(volume_now.level) == 0 then
                voluicon:set_image(theme.volume_off_icon)
            elseif tonumber(volume_now.level) <= 50 then
                voluicon:set_image(theme.volume_low_icon)
            elseif tonumber(volume_now.level) >= 50 then
                voluicon:set_image(theme.volume_icon)
            end
        widget:set_markup(markup.font(theme.font, "" .. string.format(volume_now.level) .. "%" ))
        end  
    end
})

theme.volume.widget:buttons(awful.util.table.join(
                               awful.button({}, 1, function ()
                                     awful.util.spawn("pavucontrol")
                               end),
                               awful.button({}, 4, function ()
                                     awful.util.spawn("pamixer -d 5", false)
                                     awesome.emit_signal("volume_change")
                                     theme.volume.update()
                               end),
                               awful.button({}, 5, function ()
                                     awful.util.spawn("pamixer -i 5", false)
                                     awesome.emit_signal("volume_change")
                                     theme.volume.update()
                               end)
))

-- Weather
--[[ to be set before use
theme.weather = lain.widget.weather({
    --APPID =
    city_id = 2643743, -- placeholder (London)
    settings = function()
        units = math.floor(weather_now["main"]["temp"])
        widget:set_markup(" " .. units .. " ")
    end
})
--]]

-- Separators
local first     = wibox.widget.textbox('<span font="Terminus 4"> </span>')
local arr_pre  = separators.arrow_right("alpha", theme.arrow_color)
local arr_post = separators.arrow_right(theme.arrow_color, "alpha")
local arr_pre_dark  = separators.arrow_right("alpha", theme.arrow_color_darker)
local arr_post_dark = separators.arrow_right(theme.arrow_color_darker, "alpha")
local arl_pre  = separators.arrow_left("alpha", theme.arrow_color)
local arl_post = separators.arrow_left(theme.arrow_color, "alpha")
local arl_pre_dark  = separators.arrow_left("alpha", theme.arrow_color_darker)
local arl_post_dark = separators.arrow_left(theme.arrow_color_darker, "alpha")

local barheight = dpi(5)
local barcolor  = gears.color({
    type  = "linear",
    from  = { barheight, 0 },
    to    = { barheight, barheight },
    stops = { {0, theme.bg_focus }, {0.8, theme.border_normal}, {1, "#000000"} }
})
theme.titlebar_bg = barcolor

theme.titlebar_bg_focus = gears.color({
    type  = "linear",
    from  = { barheight, 0 },
    to    = { barheight, barheight },
    stops = { {0, theme.bg_normal}, {0.5, theme.border_normal}, {1, "#010101"} }
})

function theme.at_screen_connect(s)
    -- Freedesktop
    freedesktop.desktop.add_icons({screen = s,open_with="Thunar",showlabels = true})
    
    -- Quake application
    s.quake = lain.util.quake({ app = awful.util.terminal })

    -- If wallpaper is a function, call it with the screen
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Tags
    awful.tag(awful.util.tagnames, s, awful.layout.layouts)

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.

    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)

    s.mylayoutbox:buttons(my_table.join(
                           awful.button({}, 1, function () awful.layout.inc( 1) end),
                           awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
                           awful.button({}, 3, function () awful.layout.inc(-1) end),
                           awful.button({}, 4, function () awful.layout.inc( 1) end),
                           awful.button({}, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, keys.taglistbuttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags,keys.tasklistbuttons, { bg_normal = barcolor, bg_focus = barcolor })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height = dpi(18), bg = barcolor })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.container.background(mylauncher, theme.arrow_color_darker),
            arr_post_dark,
            first,
            s.mytaglist,
            arr_pre,
            s.mylayoutbox,
            arr_post,
            s.mypromptbox,
            first,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            first,
            --theme.mail.widget,
            --theme.weather.icon,
            --theme.weather.widget,
            --theme.fs.widget,
            --battery,            
            first,
            arl_pre_dark,
            wibox.container.background(mykeyboardlayout, theme.arrow_color_darker),
            arl_post_dark, 
            first,
            wibox.widget.systray(),
            first,
            theme.volume.widget,
            voluicon,
            arl_pre_dark,
            wibox.container.background(theme.mpd.widget, theme.arrow_color_darker),
            arl_post_dark,
            mytextclock,
        },
    }
end

return theme
