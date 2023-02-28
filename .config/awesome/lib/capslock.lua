--[[

  Copyright 2017 Stefano Mazzucco <stefano AT curso DOT re>

  This program is free software: you can redistribute it and/or modify it under
  the terms of the GNU General Public License as published by the Free Software
  Foundation, either version 3 of the License, or (at your option) any later
  version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
  FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
  details.

  You should have received a copy of the GNU General Public License along with
  this program.  If not, see <https://www.gnu.org/licenses/gpl-3.0.html>.

]]

--[[
  A simple widget to show whether Caps Lock is active.
  Requirements:
  - Awesome 4.x
  - xset

  @usage
  capslock = require("capslock")
  -- Add widget to wibox
  s.mywibox:setup {
  layout = wibox.layout.align.horizontal,
  { -- Left widgets
    layout = wibox.layout.fixed.horizontal,
    capslock
  }
  -- more stuff
  }
  -- Add key to globalkeys
  globalkeys = awful.util.table.join(globalkeys, capslock.key)

]]

local awful = require("awful")
local wibox = require("wibox")

local capslock = wibox.widget {
  widget = wibox.widget.textbox,
  align = "center",
  valign = "center",
  forced_width = 15,
}

capslock.activated = "<b>A</b>"
capslock.deactivated = "<b>a</b>"

local tooltip = awful.tooltip({})

tooltip:add_to_object(capslock)

function capslock:check()
  awful.spawn.with_line_callback(
    "bash -c 'sleep 0.2 && xset q'",
    {
      stdout = function (line)
        if line:match("Caps Lock") then
          local status = line:gsub(".*(Caps Lock:%s+)(%a+).*", "%2")
          tooltip.text = "Caps Lock " .. status
          if status == "on" then
            self.markup = self.activated
          else
            self.markup = self.deactivated
          end
        end
      end
    }
  )
end

capslock.key = awful.key(
  {},
  "Caps_Lock",
  function () capslock:check() end)

capslock:check()

return capslock
