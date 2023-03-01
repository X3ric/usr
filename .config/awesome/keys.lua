--[[
██╗  ██╗███████╗██╗   ██╗███████╗
██║ ██╔╝██╔════╝╚██╗ ██╔╝██╔════╝
█████╔╝ █████╗   ╚████╔╝ ███████╗
██╔═██╗ ██╔══╝    ╚██╔╝  ╚════██║
██║  ██╗███████╗   ██║   ███████║
╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝
--]]

-- ===================================================================
-- Initialization
-- ===================================================================
local awful = require("awful")
local gears = require("gears")
local naughty = require("naughty")
local lain = require("lain")
local beautiful = require("beautiful")
local hotkeys_popup = require("lib.awful.hotkeys_popup").widget
local hotkeys_keys = require("lib.awful.hotkeys_popup.keys")

-- keys variables
local modkey       = "Mod4"
local control      = "Control"
local altkey       = "Mod1"

local dpi = beautiful.xresources.apply_dpi

-- define module table
local keys = {}

-- Move given client to given direction
local function move_client(c, direction)
-- If client is floating, move to edge
if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
    local workarea = awful.screen.focused().workarea
        if direction == "up" then
            c:geometry({nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil})
        elseif direction == "down" then
            c:geometry({nil, y = workarea.height + workarea.y - c:geometry().height - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil})
        elseif direction == "left" then
            c:geometry({x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil})
        elseif direction == "right" then
            c:geometry({x = workarea.width + workarea.x - c:geometry().width - beautiful.useless_gap * 2 - beautiful.border_width * 2, nil, nil, nil})
        end
        -- Otherwise swap the client in the tiled layout
        elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
            if direction == "up" or direction == "left" then
                awful.client.swap.byidx(-1, c)
            elseif direction == "down" or direction == "right" then
                awful.client.swap.byidx(1, c)
            end
        else
            awful.client.swap.bydirection(direction, c, nil)
        end
end

-- Resize client in given direction
local floating_resize_amount = dpi(10)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
    if awful.layout.get(mouse.screen) == awful.layout.suit.floating or (c and c.floating) then
        if direction == "up" then
            c:relative_move(0, 0, 0, -floating_resize_amount)
        elseif direction == "down" then
            c:relative_move(0, 0, 0, floating_resize_amount)
        elseif direction == "left" then
            c:relative_move(0, 0, -floating_resize_amount, 0)
        elseif direction == "right" then
            c:relative_move(0, 0, floating_resize_amount, 0)
        end
    else
        if direction == "up" then
            awful.client.incwfact(-tiling_resize_factor)
        elseif direction == "down" then
            awful.client.incwfact(tiling_resize_factor)
        elseif direction == "left" then
            awful.tag.incmwfact(-tiling_resize_factor)
        elseif direction == "right" then
            awful.tag.incmwfact(tiling_resize_factor)
        end
    end
    end

-- left click on desktop
keys.buttons = gears.table.join(
    awful.button({ }, 1, function () naughty.destroy_all_notifications() end),
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev) 
)

-- Mouse buttons on the client
keys.clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c c:raise() c:emit_signal("request::activate" , "mouse_click" , {raise = true}) end),
    awful.button({ modkey }, 1, function (c) c:emit_signal("request::activate" , "mouse_click" , {raise = true}) awful.mouse.client.move(c) end),
    awful.button({ modkey }, 3, function (c) c:emit_signal("request::activate" , "mouse_click" , {raise = true}) awful.mouse.client.resize(c) end)
)

-- Create a wibox for each screen and add it
keys.taglistbuttons = gears.table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

keys.tasklistbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            --c:emit_signal("request::activate", "tasklist", {raise = true})<Paste>

            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
            if not c:isvisible() and c.first_tag then
                c.first_tag:view_only()
            end
            -- This will also un-minimize
            -- the client, if needed
            client.focus = c
            c:raise()
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = dpi(250)}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

hotkeys_popup.add_group_rules("X-awesome", { color = "#ffffff" })

keys.globalkeys = gears.table.join(         
    awful.key({ }, "Print" , function () awful.spawn.with_shell("cd Pictures && scrot 'Arch-%Y-%m-%d-%s_screenshot_$wx$h.jpg' -e 'notify-send 'Screenshot' $f && timeout 0.5 feh --title Preview --scale-down -s -g 768x432 $f' ") end,{description = "screenshot" , group = "X-awesome"}),
    awful.key({ "Shift" }, "Print" , function () awful.spawn.with_shell("cd Pictures && scrot -l  mode=edge,style=dash,width=1,opacity=100 -s 'Arch-%Y-%m-%d-%s_screencrop_$wx$h.jpg' -e 'notify-send 'Screenshot' $f && timeout 0.5 feh --title Preview --scale-down -s $f' ") end,{description = "screencrop" , group = "X-awesome"}),
    awful.key({ modkey }, "F1" , hotkeys_popup.show_help,{description = "show help" , group="X-awesome"}),
    awful.key({ modkey }, "F2" , function () awful.util.spawn( "rofi -show drun -theme applications -show-icons" ) end,{description = "menu appfinder" , group = "X-awesome"}),
    awful.key({ modkey }, "F3" , function () awful.spawn.with_shell("$HOME/.config/awesome/scripts/dock.sh") end,{description = "menu appfavourites" , group = "X-awesome"}),
    awful.key({ modkey }, "F4" , function() awful.spawn.with_shell("$HOME/.config/awesome/scripts/picom-toggle.sh") end,{description = "Picom toggle" , group = "X-awesome"}),
    awful.key({ modkey }, "F5" , function() awful.spawn.with_shell("$HOME/.config/awesome/scripts/musiccontrol.sh") end,{description = "menu music" , group = "X-awesome"}),  
    awful.key({ modkey }, "c" , function() awful.spawn.with_shell("rofi -show calc -modi calc -no-show-match -no-sort -theme calc") end,{description = "menu calc" , group = "X-awesome"}),
    awful.key({ modkey }, "," , function() awful.spawn.with_shell("rofi -modi emoji -show emoji -theme emoji") end,{description = "menu emoji" , group = "X-awesome"}),        
    awful.key({ modkey }, "Return" , function () awful.spawn( apps.terminal ) end,{description = terminal, group = "X-awesome"}),
    awful.key({ modkey }, "w" , function () awful.util.spawn( apps.browser ) end,{description = browser, group = "X-awesome"}),
    awful.key({ modkey }, "e" , function () awful.util.spawn( apps.editorgui ) end,{description = "run gui editor" , group = "X-awesome"}),
    awful.key({ modkey }, "t" , function () awful.util.spawn( apps.terminal ) end,{description = "terminal" , group = "X-awesome"}),
    awful.key({ modkey }, "a" , function () awful.util.spawn( "pavucontrol" ) end,{description = "audio control" , group = "X-awesome"}),
    awful.key({ modkey }, "Escape" , function () awful.util.spawn( "xkill" ) end,{description = "kill proces" , group = "X-awesome"}),
    awful.key({ modkey }, "v" , function ()  awful.util.spawn("xfce4-popup-clipman") end,{description = "copy history" , group = "X-awesome"}),
    awful.key({ modkey }, "g" , function ()  awful.util.spawn("gpick -s") end,{description = "color picker" , group = "X-awesome"}),
    awful.key({ modkey }, "b" , function () for s in screen do s.mywibox.visible = not s.mywibox.visible if s.mybottomwibox then s.mybottomwibox.visible = not s.mybottomwibox.visible end end end,{description = "toggle wibox" , group = "X-awesome"}),
    awful.key({ modkey }, "\\" , function () awful.screen.focused().systray.visible = not awful.screen.focused().systray.visible end,{description = "Toggle systray visibility" , group = "X-awesome"}),
    awful.key({ modkey , "Shift" }, "x" , function () awful.spawn.with_shell("$HOME/.config/awesome/scripts/powermenu.sh") end,{description = "quit menu" , group = "X-awesome"}),
    awful.key({ modkey , "Shift" }, "d",function () awful.spawn(string.format("dmenu_run -i -nb '%s' -nf '%s' -sb '%s' -sf '%s' -fn NotoMonoRegular:bold:pixelsize=11",beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))end,{description = "show dmenu" , group = "X-awesome"}),
    awful.key({ modkey , "Shift" }, "r" , awesome.restart ,{description = "reload awesome" , group = "X-awesome"}),
    awful.key({ modkey , "Shift" }, "Return", function() awful.util.spawn( apps.filemanager ) end,{description = "file manager gui" , group = "X-awesome"}),
    awful.key({ control, "Shift"  }, "Escape", function() awful.util.spawn("kitty --start-as maximized btop") end,{description = "task manager" , group = "X-awesome"}),
    awful.key({ altkey }, "f" , function ()  awful.spawn.with_shell("cd ../.. && kitty  $HOME/.config/awesome/scripts/fzf.sh") end,{description = "root file finder" , group = "X-awesome"}),
    awful.key({ altkey }, "d" , function ()  awful.spawn.with_shell("cd ../.. && kitty  $HOME/.config/awesome/scripts/dirfzf.sh") end,{description = "dir finder" , group = "X-awesome"}),
    awful.key({ altkey }, "x", function () awful.prompt.run { prompt       = "Run Lua code: ", textbox      = awful.screen.focused().mypromptbox.widget, exe_callback = awful.util.eval, history_path = awful.util.get_cache_dir() .. "/history_eval"}end,{description = "lua execute prompt" , group = "X-awesome"}),
    --input clipboard text
    awful.key({ altkey }, "v" , function ()  awful.spawn.with_shell('current=$(xkb-switch -p);setxkbmap us -option caps:none && xdotool type "$(xclip -o)" && setxkbmap $current') end,{description = "input copied text" , group = "X-awesome"}),
    -- Tag browsing with modkey
    awful.key({ modkey }, "Left" , awful.tag.viewprev,{description = "view previous" , group = "X-tag"}),
    awful.key({ modkey }, "Right" , awful.tag.viewnext,{description = "view next" , group = "X-tag"}),
    awful.key({ modkey }, "h" , awful.tag.viewprev,{description = "view previous" , group = "X-tag"}),
    awful.key({ modkey }, "l" , awful.tag.viewnext,{description = "view next" , group = "X-tag"}),
    awful.key({ altkey }, "Escape" , awful.tag.history.restore,{description = "go back" , group = "X-tag"}),
    -- Layout
    --awful.key({ altkey , "Control" }, "l" , function () awful.tag.incmwfact( 0.05) end,{description = "layout increase master width factor" , group = "X-awesome"}),
    --awful.key({ altkey , "Control" }, "h" , function () awful.tag.incmwfact(-0.05) end,{description = "layout decrease master width factor" , group = "X-awesome"}),
    --awful.key({ modkey , "Shift" }, "h" , function () awful.tag.incnmaster( 1, nil, true) end,{description = "layout increase the number of master clients" , group = "X-awesome"}),
    --awful.key({ modkey , "Shift" }, "l" , function () awful.tag.incnmaster(-1, nil, true) end,{description = "layout decrease the number of master clients" , group = "X-awesome"}),
    --awful.key({ modkey , "Control" }, "h" , function () awful.tag.incncol( 1, nil, true) end,{description = "layout increase the number of columns" , group = "X-awesome"}),
    --awful.key({ modkey , "Control" }, "l" , function () awful.tag.incncol(-1, nil, true) end,{description = "layout decrease the number of columns" , group = "X-awesome"}),
    awful.key({ modkey }, "space" , function () awful.layout.inc( 1) end,{description = "select next layout" , group = "X-awesome"}),
    awful.key({ modkey , "Shift" }, "space" , function () awful.layout.inc(-1) end,{description = "select previous layout" , group = "X-awesome"}),
    -- Tag browsing alt + tab
    awful.key({ altkey,  }, "Tab" ,   awful.tag.viewnext,{description = "view next" , group = "X-tag"}),
    awful.key({ altkey, "Shift" }, "Tab" ,  awful.tag.viewprev,{description = "view previous" , group = "X-tag"}),
    -- Non-empty tag browsing
    awful.key({ modkey }, "Tab" , function () lain.util.tag_view_nonempty(1) end,{description = "view  next nonempty" , group = "X-tag"}),
    awful.key({ modkey , "Shift" }, "Tab" , function () lain.util.tag_view_nonempty(-1) end,{description = "view  previous nonempty" , group = "X-tag"}),
    -- On the fly useless gaps change
    awful.key({ modkey, "Control" }, "+" , function () lain.util.useless_gaps_resize(1) end,{description = "increment useless gaps" , group = "X-tag"}),
    awful.key({ modkey, "Control" }, "-" , function () lain.util.useless_gaps_resize(-1) end,{description = "decrement useless gaps" , group = "X-tag"}),
    -- Dynamic tagging
    awful.key({ modkey, "Control" }, "n" , function () lain.util.add_tag() end,{description = "add new tag" , group = "X-tag"}),
    awful.key({ modkey, "Control" }, "r" , function () lain.util.rename_tag() end,{description = "rename tag" , group = "X-tag"}),
    awful.key({ modkey, altkey }, "Next" , function () lain.util.move_tag(-1) end,{description = "move tag to the left" , group = "X-tag"}),
    awful.key({ modkey, altkey }, "Prior" , function () lain.util.move_tag(1) end,{description = "move tag to the right" , group = "X-tag"}),
    awful.key({ modkey, "Control" }, "y" , function () lain.util.delete_tag() end,{description = "delete tag" , group = "X-tag"}),
    awful.key({ modkey }, "Next" , function () awful.screen.focus_relative( 1) end,{description = "focus the next screen" , group = "X-awesome"}),
    awful.key({ modkey }, "Prior" , function () awful.screen.focus_relative(-1) end,{description = "focus the previous screen" , group = "X-awesome"})
    --[[
    awful.key({ control, "Shift" }, "m",
        function ()
            os.execute(string.format("amixer -q set %s 100%%" , beautiful.volume.channel))
            beautiful.volume.update()
        end)
    awful.key({ control, "Shift" }, "0",
        function ()
            os.execute(string.format("amixer -q set %s 0%%" , beautiful.volume.channel))
            beautiful.volume.update()
        end)
    --]]
    --Media keys supported by mpd.
    -- MPD control
    --[[
    awful.key({ control, "Shift" }, "Up",
        function ()
            --awful.util.spawn("mpc toggle")
            os.execute("mpc toggle")
            beautiful.mpd.update()
        end,{description = "mpc toggle" , group = "music"}),
    awful.key({ control, "Shift" }, "Down",
        function ()
            --awful.util.spawn("mpc stop")
            os.execute("mpc stop")
            beautiful.mpd.update()
        end,{description = "mpc stop" , group = "music"}),
    awful.key({ control, "Shift" }, "Left",
        function ()
            --awful.util.spawn("mpc prev")
            os.execute("mpc prev")
            beautiful.mpd.update()
        end,{description = "mpc prev" , group = "music"}),
    awful.key({ control, "Shift" }, "Right",
        function ()
            --awful.util.spawn("mpc next")
            os.execute("mpc next")
            beautiful.mpd.update()
        end,{description = "mpc next" , group = "music"}),
    awful.key({ control, "Shift" }, "s",
        function ()
            local common = { text = "MPD widget " , position = "top_middle" , timeout = 2 }
            if beautiful.mpd.timer.started then
                beautiful.mpd.timer:stop()
                common.text = common.text .. lain.util.markup.bold("OFF")
            else
                beautiful.mpd.timer:start()
                common.text = common.text .. lain.util.markup.bold("ON")
            end
            naughty.notify(common)
        end,{description = "widget on/off" , group = "music"}),
      --]]
    --Hotkeys
    -- Function keys
    --awful.key({ modkey }, "Insert" , function () awful.util.spawn( "" ) end,{description = "dropdown terminal" , group = "hotkeys"})
    --App menu
    --awful.key({ altkey, "Control" }, "space" ,     function () awful.util.spawn("gnomehud" , false) end,{description = "App menu" , group = "X-client"}),
    -- Bind all key numbers to tags
)

keys.clientkeys = gears.table.join(
    -- Default client focus
    awful.key({ modkey }, "Up" , function () awful.client.focus.byidx( 1) end,{description = "focus next by index" , group = "X-client"}),
    awful.key({ modkey }, "Down" , function () awful.client.focus.byidx(-1) end,{description = "focus previous by index" , group = "X-client"}),
    awful.key({ modkey }, "j" , function () awful.client.focus.byidx( 1) end,{description = "focus next by index" , group = "X-client"}),
    awful.key({ modkey }, "k" , function () awful.client.focus.byidx(-1) end,{description = "focus previous by index" , group = "X-client"}),
    awful.key({ altkey , control }, "Down",function(c) resize_client(client.focus, "down") end,{description = "resize down" , group = "X-client"}),
    awful.key({ altkey , control }, "Up",function(c) resize_client(client.focus, "up") end,{description = "resize up" , group = "X-client"}),
    awful.key({ altkey , control }, "Left",function(c) resize_client(client.focus, "left") end,{description = "resize left" , group = "X-client"}),
    awful.key({ altkey , control }, "Right",function(c) resize_client(client.focus, "right") end,{description = "resize right" , group = "X-client"}),
    awful.key({ altkey , control }, "j",function(c) resize_client(client.focus, "down") end,{description = "resize down" , group = "X-client"}),
    awful.key({ altkey , control }, "k",function(c) resize_client(client.focus, "up") end,{description = "resize up" , group = "X-client"}),
    awful.key({ altkey , control }, "h",function(c) resize_client(client.focus, "left") end,{description = "resize left" , group = "X-client"}),
    awful.key({ altkey , control }, "l",function(c) resize_client(client.focus, "right") end,{description = "resize right" , group = "X-client"}),
    awful.key({ modkey }, "f" , function(c) c.fullscreen = not c.fullscreen c:raise() end,{description = "toggle fullscreen" , group = "X-client"}),
    awful.key({ modkey }, "q" , function(c) c:kill() end,{description = "close" , group = "X-client"}),
    --awful.key({ modkey }, "o" , function(c) c:move_to_screen() end,{description = "move to screen" , group = "X-client"}),
    awful.key({ modkey }, "t" , function(c) c.ontop = not c.ontop end,{description = "toggle keep on top" , group = "X-client"}),
    awful.key({ modkey }, "y" , function(c) c.sticky = not c.sticky end,{description = "toggle sticky" , group = "X-client"}),
    awful.key({ modkey,}, "z" , function(c) 
    if not c.titlebar then 
        awful.titlebar.show(c)
        if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
            if c.class == "kitty" then c:relative_move(0, beautiful.titlebarheight, 0, -beautiful.titlebarheight)
            else
            c:relative_move(0, 0, 0, -beautiful.titlebarheight)
            end
        end
    end
    if c.titlebar then 
        awful.titlebar.hide(c)
        if c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating) then
            if c.class == "kitty" then c:relative_move(0, -beautiful.titlebarheight, 0, beautiful.titlebarheight)
            else
            c:relative_move(0, 0, 0, beautiful.titlebarheight)
            end
        end
    end
    c.titlebar = not c.titlebar
    end,{description = "toggle titlebar" , group = "X-client"}),
    awful.key({ modkey }, "n" , function (c) c.minimized = true end,{description = "minimize" , group = "X-client"}),
    awful.key({ modkey }, "m" , function (c) c.maximized = not c.maximized c:raise() end,{description = "maximize" , group = "X-client"}),
    -- Layout manipulation
    awful.key({ modkey , "Shift" }, "Next" , function () awful.client.swap.byidx(  1)    end,{description = "swap next client index" , group = "X-client"}),
    awful.key({ modkey , "Shift" }, "Prior" , function () awful.client.swap.byidx( -1)    end,{description = "swap previous client index" , group = "X-client"}),
    awful.key({ modkey }, "u" , awful.client.urgent.jumpto,{description = "jump to urgent client" , group = "X-client"}),
    awful.key({ modkey }, "-" , function() local c = client.focus if c then c.opacity = c.opacity - 0.1 end end,{description = "trasparency -" , group = "X-client"}),
    awful.key({ modkey }, "+" , function() local c = client.focus if c then c.opacity = c.opacity + 0.1 end end,{description = "trasparency +" , group = "X-client"}),
    awful.key({ modkey }, "ù" , function() local c = client.focus if c then c.opacity = 1 end end,{description = "trasparency reset" , group = "X-client"}),
    awful.key({ modkey , "Control"}, "n" , function () local c = awful.client.restore() if c then client.focus = c c:raise() end end,{description = "restore minimized" , group = "X-client"}),
    awful.key({ altkey , "Shift" }, "m" ,  lain.util.magnify_client,{description = "magnify client" , group = "X-client"}),
    awful.key({ modkey , "Shift" }, "space" ,  awful.client.floating.toggle,{description = "toggle floating" , group = "X-client"}),
    --awful.key({ modkey , "Control"}, "Return" , function (c) c:swap(awful.client.getmaster()) end,{description = "move to master" , group = "X-client"}),
    -- Move to edge or swap by direction
    awful.key({ modkey , "Shift"}, "Down",function(c) move_client(c, "down") end,{description = "move edge down" , group = "X-client"}),
    awful.key({ modkey , "Shift"}, "Up",function(c) move_client(c, "up") end,{description = "move edge up" , group = "X-client"}),
    awful.key({ modkey , "Shift"}, "Left",function(c) move_client(c, "left") end,{description = "move edge left" , group = "X-client"}),
    awful.key({ modkey , "Shift"}, "Right",function(c) move_client(c, "right") end,{description = "move edge right" , group = "X-client"}),
    awful.key({ modkey , "Shift"}, "j",function(c) move_client(c, "down") end,{description = "move edge down" , group = "X-client"}),
    awful.key({ modkey , "Shift"}, "k",function(c) move_client(c, "up") end,{description = "move edge up" , group = "X-client"}),
    awful.key({ modkey , "Shift"}, "h",function(c) move_client(c, "left") end,{description = "move edge left" , group = "X-client"}),
    awful.key({ modkey , "Shift"}, "l",function(c) move_client(c, "right") end,{description = "move edge right" , group = "X-client"}),
    -- By direction client focus
    awful.key({ control , modkey }, "Down", function() awful.client.focus.global_bydirection("down") if client.focus then client.focus:raise() end end,{description = "focus down" , group = "X-client"}),
    awful.key({ control , modkey }, "Up", function() awful.client.focus.global_bydirection("up") if client.focus then client.focus:raise() end end,{description = "focus up" , group = "X-client"}),
    awful.key({ control , modkey }, "Left", function() awful.client.focus.global_bydirection("left") if client.focus then client.focus:raise() end end,{description = "focus left" , group = "X-client"}),
    awful.key({ control , modkey }, "Right", function() awful.client.focus.global_bydirection("right") if client.focus then client.focus:raise() end end,{description = "focus right" , group = "X-client"}),
    awful.key({ control , modkey }, "j",function() awful.client.focus.global_bydirection("down") if client.focus then client.focus:raise() end end,{description = "focus down" , group = "X-client"}),
    awful.key({ control , modkey }, "k",function() awful.client.focus.global_bydirection("up") if client.focus then client.focus:raise() end end, {description = "focus up" , group = "X-client"}),
    awful.key({ control , modkey }, "h",function() awful.client.focus.global_bydirection("left") if client.focus then client.focus:raise() end end,{description = "focus left" , group = "X-client"}),
    awful.key({ control , modkey }, "l",function() awful.client.focus.global_bydirection("right") if client.focus then client.focus:raise() end end,{description = "focus right" , group = "X-client"})

)

keys.globalkeys = gears.table.join(keys.globalkeys,
    awful.key({ }, "#225" , function () os.execute("xbacklight -inc 10") end),
    awful.key({ }, "#224" , function () os.execute("xbacklight -dec 10") end),
    awful.key({ }, "XF86AudioPlay" , function () awful.util.spawn("mpc toggle") beautiful.mpd.update() end),
    awful.key({ }, "XF86AudioNext" , function () awful.util.spawn("mpc next") beautiful.mpd.update() end),
    awful.key({ }, "XF86AudioPrev" , function () awful.util.spawn("mpc prev") beautiful.mpd.update() end),
    awful.key({ }, "XF86AudioStop" , function () awful.util.spawn("mpc stop") beautiful.mpd.update() end),
    --volume-adjust keys   enable in theme line 107 and disable keys in volume icon
    awful.key({ }, "XF86AudioRaiseVolume" , function () awful.util.spawn("pamixer -i 1" , false) awesome.emit_signal("volume_change") beautiful.volume.update() end),
    awful.key({ }, "XF86AudioLowerVolume" , function () awful.util.spawn("pamixer -d 1" , false) awesome.emit_signal("volume_change") beautiful.volume.update() end),
    awful.key({ }, "XF86AudioMute" , function () awful.util.spawn("pamixer --toggle-mute" , false) awesome.emit_signal("volume_change") beautiful.volume.update() end)
    --Media keys supported by vlc, spotify, audacious, xmm2, firefox ..
    --awful.key({control}, "F9" , function() awful.util.spawn("playerctl play-pause" , false) end,{description = "play/pause" , group = "music"}),
    --awful.key({control}, "F12" , function() awful.util.spawn("playerctl next" , false) end,{description = "next" , group = "music"}),
    --awful.key({control}, "F11" , function() awful.util.spawn("playerctl previous" , false) end,{description = "prev" , group = "music"}),
    --awful.key({control}, "F10" , function() awful.util.spawn("playerctl stop" , false) end,{description = "stop" , group = "music"})
)

for i = 1, 9 do
    keys.globalkeys = gears.table.join(keys.globalkeys,       
    -- Switch to tag
    awful.key({ modkey }, "#" .. i + 9,
    function ()
        local screen = awful.screen.focused()
        local tag = screen.tags[i]
        if tag then
            tag:view_only()
        end
    end,
    {description = "view tag #" , group = "X-tag"}),
    -- Toggle tag display.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
            function ()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                awful.tag.viewtoggle(tag)
                end
            end,
    {description = "toggle tag #" , group = "X-tag"}),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        tag:view_only()
                    end
            end
            end,
    {description = "move focused client to tag #" , group = "X-tag"}),
    -- Toggle tag on focused client.
    awful.key({ modkey, "Control" , "Shift" }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
    {description = "toggle focused client on tag #" , group = "X-tag"}))
end

return keys

-- ===================================================================
-- Client bindings   sudo showkey  for see what key you are pressing
-- =================================================================== 
