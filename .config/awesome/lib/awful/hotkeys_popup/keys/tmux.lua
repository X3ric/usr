local hotkeys_popup = require("lib.awful.hotkeys_popup.widget")
local tmux_rule = { name = { '%d+ %[.+ %- %/.+%/.+%] .+' } }
for group_name, group_data in pairs({
    ["#tmux: sessions"] = { color="#6042f5", rule_any=tmux_rule },
    ["#tmux: windows"]  = { color="#573cde", rule_any=tmux_rule },
    ["#tmux: panes"]    = { color="#513db8", rule_any=tmux_rule },
    ["#tmux: misc"]     = { color="#6255a3", rule_any=tmux_rule },
}) do
    hotkeys_popup.add_group_rules(group_name, group_data)
end

local tmux_keys = {
    ["#tmux: sessions"] = {{
        modifiers = {},
        keys = {
            s     = "show all sessions",
            ['$'] = "rename the current session",
            ['('] = "move to previous session",
            [')'] = "move to next session",
            d     = "detach from current session"
        }
    }},

    ["#tmux: windows"] = {{
        modifiers = {},
        keys = {
            c         = "create window",
            f         = "find window",
            [',']     = "rename current window",
            --['&']     = "close current window",
            p         = "previous window",
            n         = "next window",
            ['0...9'] = "select window by number"
        }
    }},

    ["#tmux: panes"] = {{
        modifiers = {},
        keys = {
            [';']       = "toggle last active pane",
            ['%']       = "split pane vertically",
            ['"']       = "split pane horizontally",
            ['{']       = "move the current pane left",
            ['}']       = "move the current pane right",
            ['q 0...9'] = "select pane by number",
            o           = "toggle between panes",
            z           = "toggle pane zoom",
            ['space']   = "toggle between layouts",
            ['!']       = "convert pane into a window",
            x           = "close current pane"
        }
    }},

    ["#tmux: misc"] = {{
        modifiers = {},
        keys = {
            [':'] = "enter command mode",
            ['?'] = "list shortcuts",
            t     = "show clock"
        }
    }}
}

hotkeys_popup.add_hotkeys(tmux_keys)

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
