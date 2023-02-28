local helpers = require("lain.helpers")
local shell   = require("awful.util").shell
local wibox   = require("wibox")
local string  = string

-- pipewire volume
-- lain.widget.pipewire

local function factory(args)
    args           = args or {}
    local pipewire     = { widget = args.widget or wibox.widget.textbox() }
    local timeout  = args.timeout or 5
    local settings = args.settings or function() end

    pipewire.cmd           = args.cmd or "pamixer --get-volume-human"

    local format_cmd = string.format("%s",pipewire.cmd)

    pipewire.last = {}

    function pipewire.update()
        helpers.async(format_cmd, function(mixer)
            local l = string.match(mixer, "([%d]+)")
            if pipewire.last.level ~= nil or pipewire.last.level ~= 0 then
                volume_now = { level = tonumber(l)}
                widget = pipewire.widget
                settings()
                pipewire.last = volume_now
            end
        end)
    end

    helpers.newtimer(string.format("%s", pipewire.cmd), timeout, pipewire.update)

    return pipewire
end

return factory
