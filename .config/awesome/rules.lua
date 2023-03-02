--      ██████╗ ██╗   ██╗██╗     ███████╗███████╗
--      ██╔══██╗██║   ██║██║     ██╔════╝██╔════╝
--      ██████╔╝██║   ██║██║     █████╗  ███████╗
--      ██╔══██╗██║   ██║██║     ██╔══╝  ╚════██║
--      ██║  ██║╚██████╔╝███████╗███████╗███████║
--      ╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================

local awful = require("awful")
local beautiful = require("beautiful")

-- define screen height and width
local screen_height = awful.screen.focused().geometry.height
local screen_width = awful.screen.focused().geometry.width

-- ===================================================================
-- Client rules              view window rules xprop
-- ===================================================================
-- to wiev class name          xprop | grep 'CLASS'

-- define module table
local rules = {
}

-- ===================================================================
-- Rules
-- ===================================================================

-- return a table of client rules including provided keys / buttons
function rules.create(clientkeys, clientbuttons)

      return {

      -- All clients will match this rule.
      { rule_any = {name = {"rofi"}} , properties = {maximized = true, floating = true, titlebars_enabled = false}},

      { rule = {class = "feh" , name = "Preview" } , properties = {floating = true},
      callback = function (c)
         awful.placement.centered(c,nil)
      end},
      
      -- Titlebars
      --{ rule_any = { type = { "dialog", "normal" } },properties = {titlebars_enabled = beautiful.titlebars_enabled} },   --simil windows titlebars whit all options       
      { rule = { class = "firefox" , instance = "Toolkit" },properties = {titlebars_enabled = true, floating = true , sticky = true} },
      { rule = { class = "discord" , role = "browser-window"},properties = {titlebars_enabled = false ,screen = 1, tag = awful.util.tagnames[2], switchtotag = true} }, 
      --{ rule = { class = "kitty" },properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },
      --{ rule = { class = "pavucontrol , Pavucontrol" },properties = { screen = 1, tag = awful.util.tagnames[1], switchtotag = true  } },
      --{ rule = { class = "Thunar" },properties = { maximized = false, floating = false } },       
      --{ rule = { class = apps.browser },properties = { screen = 1, tag = awful.util.tagnames[1], switchtotag = true  } },
      --{ rule = { class = apps.editorgui },properties = { screen = 1, tag = awful.util.tagnames[2], switchtotag = true  } },

      -- All clients will match this rule.
      {
         rule = {},
         properties = {
            titlebars_enabled = beautiful.titlebars_enabled,
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            --placement = awful.placement.centered
            placement = awful.placement.no_overlap+awful.placement.no_offscreen,
            size_hints_honor = false
         },
      },

      -- Fullscreen clients
      {
         rule_any = {
            class = {
               "Terraria.bin.x86",
            },
         }, properties = {fullscreen = true}
      },

      -- "Switch to tag"
      -- These clients make you switch to their tag when they appear
      {
         rule_any = {
            class = {
               "Firefox",
               "code-oss",
            },
         }, properties = {switchtotag = true}
      },

      -- Floating clients.
      { rule_any = {
          instance = {
            "DTA",
            "copyq"
          },
          class = {
            "conky",
            "Unity",
            "UnityHub",
            "Arandr",
            "Blueberry",
            "Gpick",
            "discord",
            "xtightvncviewer",
            "Xfce4-terminal",
            "Xfce4-settings-manager"
         },
          name = {
            "Event Tester",  -- xev.
            "Steam Guard - Computer Authorization Required"
          },
          role = {
            "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
            "Preferences",
            "GtkFileChooserDialog",
            "setup"
          },
          type = {
            "dialog"
          },
        },properties = { floating = true }
      },

      -- No Tilebars
      { rule_any = {
        class = {
            "firefox",
            "Blueberry.py",
            "Gnome-disks",
            "File-roller",
            "Pamac-manager"}
      },properties = { titlebars_enabled = false }
      },

      -- Floating clients but centered in screen
      { rule_any = {
            class = {
                "Polkit-gnome-authentication-agent-1"
                    },
                    },
            properties = { floating = true },
                callback = function (c)
                awful.placement.centered(c,nil)
                end
      },

      -- File chooser dialog
      {
         rule_any = {role = {"GtkFileChooserDialog"}},
         properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.65}
      },

      -- Pavucontrol & Bluetooth Devices
      {
         rule_any = {class = {"Pavucontrol"}, name = {"Bluetooth Devices"}},
         properties = {floating = true, width = screen_width * 0.55, height = screen_height * 0.45}
      },
      
   }
end

-- return module table
return rules