--[[
 █████╗ ██╗    ██╗███████╗███████╗ ██████╗ ███╗   ███╗███████╗
██╔══██╗██║    ██║██╔════╝██╔════╝██╔═══██╗████╗ ████║██╔════╝
███████║██║ █╗ ██║█████╗  ███████╗██║   ██║██╔████╔██║█████╗
██╔══██║██║███╗██║██╔══╝  ╚════██║██║   ██║██║╚██╔╝██║██╔══╝
██║  ██║╚███╔███╔╝███████╗███████║╚██████╔╝██║ ╚═╝ ██║███████╗
╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝╚══════╝ ╚═════╝ ╚═╝     ╚═╝╚══════╝

Freedesktop : https://github.com/lcpz/awesome-freedesktop

lain : https://github.com/lcpz/lain
--]]

-- Standard awesome libraries
-- {{{ Required libraries
local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

--https://awesomewm.org/doc/api/documentation/05-awesomerc.md.html

-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears         = require("gears") --Utilities such as color parsing and objects
local awful         = require("awful") --Everything related to window managment
-- Autofocus a new client when previously focused one is closed
                      require("awful.autofocus")
-- Widget and layout library
local wibox         = require("wibox")
-- Notification library
local naughty       = require("naughty")
naughty.config.defaults['icon_size'] = 100

local lain          = require("lain")

-- Theme handling library
local beautiful     = require("beautiful")
local dpi           = require("beautiful.xresources").apply_dpi

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Autostart windowless processes
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

run_once({ "unclutter -root" }) -- entries must be comma-separated
-- }}}

-- This function implements the XDG autostart specification
--[[
awful.spawn.with_shell(
    'if (xrdb -query | grep -q "^awesome\\.started:\\s*true$"); then exit; fi;' ..
    'xrdb -merge <<< "awesome.started:true";' ..
    -- list each of your autostart commands, followed by ; inside single quotes, followed by ..
    'dex --environment Awesome --autostart --search-paths "$XDG_CONFIG_DIRS/autostart:$XDG_CONFIG_HOME/autostart"' -- https://github.com/jceb/dex
)
--]]

-- }}}

-- {{{ Variable definitions

-- ===================================================================
-- User Configuration
-- ===================================================================
-- define default apps (global variable so other components can access it)

apps = {
    browser           = "firefox",
    editor            = "kitty nvim",
    mediaplayer       = "kitty ncmppp",
    editorgui         = "code",
    filemanager       = "thunar",
    terminal          = "kitty"
}

local themes = {
    "dark",		   -- 1
}

-- choose your theme here
local chosen_theme = themes[1]
local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
-- Load selected theme
beautiful.init(theme_path)

-- awesome variables
awful.util.terminal = apps.terminal
awful.layout.suit.tile.left.mirror = true

awful.layout.layouts = {
awful.layout.suit.magnifier,
awful.layout.suit.max,
awful.layout.suit.floating,
awful.layout.suit.tile.left,
awful.layout.suit.tile,
lain.layout.centerwork,
lain.layout.centerwork.horizontal,
awful.layout.suit.tile.left,
awful.layout.suit.tile.bottom,
awful.layout.suit.tile.top,
--awful.layout.suit.fair,
--awful.layout.suit.fair.horizontal,
--awful.layout.suit.spiral,
--awful.layout.suit.spiral.dwindle,
--awful.layout.suit.max.fullscreen,
--awful.layout.suit.corner.nw,
--awful.layout.suit.corner.ne,
--awful.layout.suit.corner.sw,
--awful.layout.suit.corner.se,
--lain.layout.cascade,
--lain.layout.cascade.tile,
--lain.layout.termfair,
--lain.layout.termfair.center,
}

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = dpi(2)
lain.layout.cascade.tile.offset_y      = dpi(32)
lain.layout.cascade.tile.extra_padding = dpi(5)
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

-- Import Keybinds
local keys = require("keys")
root.buttons(keys.buttons)
root.keys(keys.globalkeys)

 -- Import rules
local create_rules = require("rules").create awful.rules.rules = create_rules(keys.clientkeys, keys.clientbuttons)

require("lib.volumebar")

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

-- No borders when rearranging only 1 non-floating or maximized client
screen.connect_signal("arrange", function (s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized then
            c.border_width = 2
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s)
    s.systray = wibox.widget.systray()
    s.systray.visible = true
 end)

--Trasparent if not focuse
local transparency_unfocussed = 0.1

client.connect_signal("focus", function(c)
    c.border_color = beautiful.border_focus
    c.opacity = c.opacity + transparency_unfocussed
 end)
 
client.connect_signal("unfocus", function(c)
    c.border_color = beautiful.border_normal
    c.opacity = c.opacity - transparency_unfocussed
   end)

-- Focus urgent clients automatically
client.connect_signal("property::urgent", function(c)
    c.minimized = false
    c:jump_to()
end)

-- load tag
local last_tag_file = string.format("%s/.config/awesome/last-tag.x", os.getenv("HOME"))
function loadtag()
    local f = assert(io.open(last_tag_file,"r"))
    tag_name = f:read("*line")
    f:close()
    local t = awful.tag.find_by_name(nil, tag_name)
    if t then t:view_only() end
end

-- save tag
function savetag()
    local f = assert(io.open(last_tag_file,"w"))
    local t = awful.screen.focused().selected_tag
    f:write(t.name, "\n")
    f:close()
end

-- save current tag
awesome.connect_signal("exit", function (c)
	-- We are about to exit / restart awesome, save our last used tag
	savetag()
end)

-- load current tag
awesome.connect_signal("startup", function (c)
	-- We are about to exit / restart awesome, save our last used tag
	loadtag()
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end
    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)

    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end
    -- Default
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )
    awful.titlebar(c, {size = dpi(beautiful.titlebarheight)}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- ===================================================================
-- Client Focusing
-- ===================================================================
-- Focus clients under mouse
client.connect_signal("mouse::enter", function(c) c:emit_signal("request::activate", "mouse_enter", {raise = false}) end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

-- ===================================================================
-- Screen Change Functions (ie multi monitor)
-- ===================================================================


-- Reload config when screen geometry changes
screen.connect_signal("property::geometry", awesome.restart)


-- ===================================================================
-- Garbage collection (allows for lower memory consumption)
-- ===================================================================


collectgarbage("setpause", 110)
collectgarbage("setstepmul", 1000)


-- Autostart applications
awful.spawn.with_shell("~/.config/awesome/configs/autostart.sh")
awful.spawn.with_shell("tmux source-file ~/.config/awesome/configs/tmux.conf")
awful.spawn.with_shell("picom --experimental-backend -b --config  $HOME/.config/awesome/configs/picom.conf")


